package rescue1011;

import xclipsjni.ClipsModel;
import xclipsjni.ClipsException;

/**L'implementazione della classe ClipsModel specifica per il progetto Rescue 2010/2011.
 *
 * @author Piovesan Luca, Verdoja Francesco
 */
public class RescueModel extends ClipsModel {

	private String[][] map;
	private boolean loaded;
	private String direction;
	private Integer time;
	private Integer maxduration;
	private String result;
	private String communications;
	private int score;

	/**Costruttore del modello per il progetto Rescue
	 * 
	 */
	public RescueModel() {
		super();
	}

	/**Inizializza il modello in base al contenuto del file clips caricato.
	 * 
	 */
	private synchronized void init() {
		result = "no";
		time = 0;
		maxduration = Integer.MAX_VALUE;
		try {
			System.out.println("RICERCA DEI PARAMETRI DI FINE IN CORSO...");
			maxduration = new Integer(core.findOrderedFact("MAIN", "maxduration"));
			System.out.println("INIZIALIZZAZIONE DELLA MAPPA IN CORSO...");
			String[] array = {"pos-r", "pos-c", "contains"};
			String[][] mp = core.findAllFacts("MAIN", "prior_cell", "TRUE", array);
			int maxr = 0;
			int maxc = 0;
			for (int i = 0; i < mp.length; i++) {
				int r = new Integer(mp[i][0]);
				int c = new Integer(mp[i][1]);
				if (r > maxr) {
					maxr = r;
				}
				if (c > maxc) {
					maxc = c;
				}
			}
			map = new String[maxr][maxc];
			for (int i = 0; i < mp.length; i++) {
				int r = new Integer(mp[i][0]);
				int c = new Integer(mp[i][1]);
				map[r - 1][c - 1] = mp[i][2];
			}
			System.out.println("INIZIALIZZATA LA MAPPA");
		} catch (ClipsException ex) {
			System.out.println("SI E' VERIFICATO UN ERRORE DURANTE L'INIZIALIZZAZIONE: ");
			System.out.println(ex.toString());
		}
	}

	/**Aggiorna la mappa leggendola dal file clips
	 * 
	 * @throws ClipsException 
	 */
	private synchronized void updateMap() throws ClipsException {
		System.out.println("AGGIORNAMENTO MAPPA IN CORSO...");
		String[] array = {"pos-r", "pos-c", "contains"};
		String[][] mp;
		mp = core.findAllFacts("ENV", "cell", "TRUE", array);
		for (int i = 0; i < mp.length; i++) {
			int r = new Integer(mp[i][0]);
			int c = new Integer(mp[i][1]);
			map[r - 1][c - 1] = mp[i][2];
		}
		System.out.println("...RIEMPITA BASE...");
		String[] arrayDebris = {"pos-r", "pos-c", "person"};
		String[][] debris = core.findAllFacts("ENV", "debriscontent", "TRUE", arrayDebris);
		for (int i = 0; i < debris.length; i++) {
			int r = new Integer(debris[i][0]);
			int c = new Integer(debris[i][1]);
			String person = debris[i][2];
			if (person.equalsIgnoreCase("yes")) {
				map[r - 1][c - 1] = "debris_person";
			} else {
				map[r - 1][c - 1] = "debris";
			}
		}
		System.out.println("...INSERITE LE MACERIE...");
		String[] arrayRobot = {"pos-r", "pos-c", "direction", "loaded", "time"};
		//"eq ?f:time " + time
		String[] robot = core.findFact("ENV", "agentstatus", "TRUE", arrayRobot);
		if (robot[0] != null) {
			int r = new Integer(robot[0]);
			int c = new Integer(robot[1]);
			direction = robot[2];
			loaded = robot[3].equalsIgnoreCase("yes");
			map[r - 1][c - 1] = "robot";
		}
		System.out.println("...AGGIORNATO LO STATO DEL ROBOT...");
		String[] arrayStatus = {"time", "result"};
		String[] status = core.findFact("MAIN", "status", "TRUE", arrayStatus);
		if (status[0] != null) {
			time = new Integer(status[0]);
			result = status[1];
			System.out.println("TIME: " + time + " RESULT: " + result);
		}
		System.out.println("...AGGIORNATO LO STATUS...");
		String[] arrayExec = {"action", "param1", "param2"};
		String[] exec = core.findFact("MAIN", "exec", "= ?f:time " + time, arrayExec);
		if (exec[0] != null && exec[0].equalsIgnoreCase("inform")) {
			communications = "time: " + time + ", inform about (" + exec[1] + "," + exec[2] + ")";
		} else {
			communications = null;
		}
		System.out.println("...AGGIORNATE LE COMUNICAZIONI...");
		System.out.println("AGGIORNAMENTO COMPLETATO");
	}

	/**metodo per ottenere tutte le comunicazioni fatte dall'agente fino a questo momento.
	 * 
	 * @return una stringa contenente le comunicazioni
	 */
	public synchronized String getCommunications() {
		return communications;
	}

	/**metodo per ottenere se l'agente è carico o scarico
	 * 
	 * @return true se l'agente ha caricato dei detriti, false altrimenti
	 */
	public synchronized boolean isLoaded() {
		return loaded;
	}

	/**metodo per ottenere la mappa dell'ambiente come vista nel modulo ENV.
	 * 
	 * @return la mappa come matrice di stringhe
	 */
	public synchronized String[][] getMap() {
		return map;
	}

	/**metodo per ottenere il verso in cui è girato l'agente
	 * 
	 * @return up, down, left, right
	 */
	public synchronized String getDirection() {
		return direction;
	}

	/**metodo per ottenere il punteggio dell'agente totalizzato a seguito delle sue azioni
	 * 
	 * @return il punteggio come intero
	 */
	public synchronized int getScore() {
		return score;
	}

	/**metodo per ottenere il motivo della terminazione dell'ambiente
	 * 
	 * @return disaster, done
	 */
	public synchronized String getResult() {
		return result;
	}

	/**metodo da chiamare per ottenere il turno attuale
	 * 
	 * @return il turno attuale come intero
	 */
	public synchronized int getTime() {
		return time;
	}

	/**metodo per ottenere il tempo massimo a disposizione dell'agente
	 * 
	 * @return il tempo massimo come intero
	 */
	public synchronized int getMaxDuration() {
		return maxduration;
	}

	@Override
	protected void setup() throws ClipsException {
		init();
	}

	@Override
	protected void action() throws ClipsException {
		updateMap();
	}

	@Override
	protected boolean hasDone() {
		//finisce se time==maxduration
		if (time >= maxduration) {
			return true;
		}
		//o se result e' "disaster" o "done"
		return (!result.equalsIgnoreCase("no"));
	}

	@Override
	protected void dispose() throws ClipsException {
		score = new Integer(core.findOrderedFact("MAIN", "penalty"));
	}
}
