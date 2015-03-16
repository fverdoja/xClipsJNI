package rescue1011;

import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.GridLayout;
import java.awt.Image;
import java.io.File;
import java.util.Observer;
import javax.swing.ImageIcon;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;
import xclipsjni.ClipsView;

/**L'implementazione della classe ClipsView specifica per il progetto Rescue 2010/2011
 *
 * @author Piovesan Luca, Verdoja Francesco
 */
public class RescueView extends ClipsView implements Observer {

	private RescueModel model;
	private JFrame view;
	private JPanel mapPanel;
	private JLabel[][] map;
	private JTextArea messageArea;
	private final int MAP_DIMENSION = 550;

	/** È il costruttore da chiamare nel main per avviare l'intero sistema,
	 * apre una nuova finestra con il controller, pronto per caricare il file .clp
	 * 
	 */
	public RescueView() {
		model = new RescueModel();
		model.addObserver((Observer) this);
		initializeInterface();
	}

	@Override
	protected void onSetup() {
		System.out.println("setupDone");
		initializeMap();
	}

	@Override
	protected void onAction() {
		System.out.println("actionDone");
		updateMap();
		updateMessages();
	}

	@Override
	protected void onDispose() {
		System.out.println("disposeDone");
		String result = model.getResult();
		int score = model.getScore();
		String advise = "";
		if (result.equals("disaster")) {
			advise = "DISASTRO\n";
		} else if (model.getTime() == model.getMaxDuration()) {
			advise = "MAXDURATION RAGGIUNTA\n";
		} else {
			advise = "Il robot ha comunicato DONE\n";
			messageArea.append("time: " + model.getTime() + ", done");
		}
		advise = advise + "penalties: " + score;
		JOptionPane.showMessageDialog(mapPanel, advise, "Termine Esecuzione", JOptionPane.INFORMATION_MESSAGE);
	}

	/**Chiamato nel costruttore inizializza l'interfaccia della finestra, caricando il modulo del pannello di controllo.
	 * 
	 */
	private void initializeInterface() {
		view = new JFrame();
		view.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		view.setSize(new Dimension(500, 150));
		view.setResizable(false);
		view.setTitle("Rescue 2010/2011");
		view.setLayout(new BorderLayout());
		view.add(createControlPanel(model), BorderLayout.NORTH);
		view.setVisible(true);
	}

	/**Crea la prima versione della mappa, quella corrispondente all'avvio dell'ambiente.
	 * 
	 */
	private void initializeMap() {
		String[][] mapString = model.getMap();
		int x = mapString.length;
		int y = mapString[0].length;
		map = new JLabel[x][y];
		int cellDimension = Math.round(MAP_DIMENSION / x);

		messageArea = new JTextArea();
		messageArea.setRows(5);
		JScrollPane scroll = new JScrollPane(messageArea);
		view.add(scroll, BorderLayout.CENTER);

		mapPanel = new JPanel();
		mapPanel.setLayout(new GridLayout(x, y));
		view.add(mapPanel, BorderLayout.SOUTH);

		for (int i = x - 1; i >= 0; i--) {
			for (int j = 0; j < y; j++) {
				String direction = "";
				String loaded = "";
				if (mapString[i][j].equals("robot")) {
					direction = model.getDirection();
					if (model.isLoaded()) {
						loaded = "Debris";
					}
				}
				ImageIcon icon = new ImageIcon("img" + File.separator + mapString[i][j] + direction + loaded + ".jpg");
				Image image = icon.getImage().getScaledInstance(cellDimension, cellDimension, Image.SCALE_SMOOTH);
				icon = new ImageIcon(image);
				map[i][j] = new JLabel(icon);
				map[i][j].setToolTipText("(" + (i + 1) + ", " + (j + 1) + ")");
				mapPanel.add(map[i][j]);
			}
		}
		view.pack();
	}

	/**Aggiorna la mappa visualizzata nell'interfaccia per farla allineare alla versione nel modello.
	 * 
	 */
	private void updateMap() {
		String[][] mapString = model.getMap();
		int cellDimension = Math.round(MAP_DIMENSION / map.length);

		for (int i = map.length - 1; i >= 0; i--) {
			for (int j = 0; j < map[0].length; j++) {
				String direction = "";
				String loaded = "";
				if (mapString[i][j].equals("robot")) {
					direction = model.getDirection();
					if (model.isLoaded()) {
						loaded = "Debris";
					}
				}
				ImageIcon icon = new ImageIcon("img" + File.separator + mapString[i][j] + direction + loaded + ".jpg");
				Image image = icon.getImage().getScaledInstance(cellDimension, cellDimension, Image.SCALE_SMOOTH);
				icon = new ImageIcon(image);
				map[i][j].setIcon(icon);
				map[i][j].repaint();
			}
		}
		System.out.println("TURNO > " + model.getTime());
	}

	/**Aggiorna i messaggi nel pannello dei messaggi
	 * 
	 */
	private void updateMessages() {
		String message = model.getCommunications();
		if (message != null) {
			messageArea.append(message + "\n");
		}
	}

	@SuppressWarnings("ResultOfObjectAllocationIgnored")
	public static void main(String[] args) {
		new RescueView();
	}
}
