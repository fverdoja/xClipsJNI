package xclipsjni;

import net.sf.clipsrules.jni.*;
import java.io.File;
import java.util.StringTokenizer;

/**
 * Questa classe implemente il cuore di connessione con l'ambiente clips,
 * estende e migliora i metodi già offerti dalle librerie ClipsJNI, che usa per
 * interfacciarsi a clips.
 *
 * @author Piovesan Luca, Verdoja Francesco
 */
public class ClipsCore {

    private Environment clips;
    private RouterDialog router;

    /**
     * Costruisce una nuova istanza di clips e carica un file clp
     *
     * @param path il percorso del file da caricare
     */
    public ClipsCore(String path) {
        clips = new Environment();
        clips.load(path);
        String extensionsPath = "extensions" + File.separator + "regolaHalt.clp";
        clips.load(extensionsPath);
        router = new RouterDialog("routerCore");
        clips.addRouter(router);
    }

    private void throwException(Exception ex) throws ClipsException {
        throw new ClipsException(ex.getMessage());
    }

    /**
     * Metodo da usare con cautela, serve per un comando su un modulo in clips.
     * La sintassi dev'essere quella di clips, non verranno eseguiti controlli
     * sulla stringa passata, quindi fare attenzione.
     *
     * @param module il modulo su cui svolgere l'interrogazione
     * @param eval l'interrogazione da passare a clips
     * @return un PrimitiveValue che contiene il risultato dell'interrogazione
     */
    private PrimitiveValue evaluate(String module, String eval) {
        boolean isModuleOk = true;
        PrimitiveValue fc = clips.eval("(get-focus)");
        String focus = fc.toString();
        if (!focus.equals(module)) {
            isModuleOk = false;
            clips.eval("(focus " + module + ")");
        }
        PrimitiveValue result = clips.eval(eval);
        if (!isModuleOk) {
            clips.eval("(pop-focus)");
        }
        return result;
    }

    /**
     * Resetta l'Environment Clips: cancella tutti i facts presenti nella WM e
     * asserisce tutti i facts dichiarati negli initial
     *
     */
    public void reset() {
        clips.reset();
    }

    /**
     * Equivalente al run di Clips
     *
     */
    public void run() {
        clips.run();
    }

    /**
     * Equivalente ad eseguire step l volte
     *
     * @param l il numero di "passi" da fare
     */
    public void run(long l) {
        clips.run(l);
    }

    /**
     * Equivalente allo step di Clips
     *
     */
    public void step() {
        clips.run(1);
    }

    /**
     * Equivalente alla funzione di Clips find-all-facts (vedere manuale per
     * maggiori informazioni e sintassi delle conditions). Restituisce tutti i
     * facts corrispondenti ad una certa interrogazione. Prestare attenzione
     * alla precisione nei campi inseriti, che devono corrispondere ai campi del
     * file Clips.
     *
     * @param module il modulo in cui sono visibili i facts
     * @param template il "tipo" di fatto non ordinato a cui si e' interessati
     * @param conditions le condizioni di ricerca dei facts, inserire TRUE se si
     * vogliono tutti i facts di un certo tipo
     * @param slots gli slot dei facts che si vuole vengano restituiti
     * @return una tabella di stringhe in cui ad ogni riga corrisponde un fatto
     * che soddisfa l'interrogazione, e ad ogni colonna uno slot di quel fatto,
     * secondo l'ordine in cui sono dichiarati nel campo slots. null se non c'e'
     * nessun fatto che soddisfa l'interrogazione
     * @throws ClipsException
     */
    public String[][] findAllFacts(String module, String template, String conditions, String[] slots) throws ClipsException {
        if (!conditions.equalsIgnoreCase("TRUE")) {
            conditions = "(" + conditions + ")";
        }
        String eval = "(find-all-facts ((?f " + template + ")) " + conditions + ")";
        MultifieldValue facts = (MultifieldValue) evaluate(module, eval);
        try {
            String[][] result = new String[facts.size()][slots.length];
            for (int i = 0; i < facts.size(); i++) {
                FactAddressValue fact = (FactAddressValue) facts.get(i);
                for (int j = 0; j < slots.length; j++) {
                    result[i][j] = fact.getFactSlot(slots[j]).toString();
                }
            }
            return result;
        } catch (Exception ex) {
            throwException(ex);
        }
        return null;
    }

    /**
     * Equivalente alla funzione di Clips find-fact(vedere manuale per maggiori
     * informazioni e sintassi delle conditions). Restituisce il primo fatto non
     * ordinato corrispondente ad una certa interrogazione. Prestare attenzione
     * alla precisione nei campi inseriti, che devono corrispondere ai campi del
     * file Clips.
     *
     * @param module il modulo in cui e' visibile il fatto
     * @param template il "tipo" di fatto non ordinato a cui si e' interessati
     * @param conditions le condizioni di ricerca del fatto, inserire TRUE se
     * non ci sono condizioni
     * @param slots gli slot del fatto che si vuole vengano restituiti
     * @return un array di stringhe in cui ad ogni colonna corrisponde uno slot
     * di quel fatto, secondo l'ordine in cui sono dichiarati nel campo slots.
     * null se non c'e' nessun fatto che corrisponde all'interrogazione
     * @throws ClipsException
     */
    public String[] findFact(String module, String template, String conditions, String[] slots) throws ClipsException {
        if (!conditions.equalsIgnoreCase("TRUE")) {
            conditions = "(" + conditions + ")";
        }
        String eval = "(find-fact ((?f " + template + ")) " + conditions + ")";
        MultifieldValue facts = (MultifieldValue) evaluate(module, eval);
        try {
            String[] result = new String[slots.length];
            if (facts.size() > 0) {
                FactAddressValue fact = (FactAddressValue) facts.get(0);
                for (int j = 0; j < slots.length; j++) {
                    result[j] = fact.getFactSlot(slots[j]).toString();
                }
            }
            return result;
        } catch (Exception ex) {
            throwException(ex);
        }
        return null;
    }

    /**
     * Versione per facts ordinati della funzione di Clips find-fact.
     * Restituisce il primo fatto ordinato corrispondente ad una certa
     * interrogazione. Prestare attenzione alla precisione nei campi inseriti,
     * che devono corrispondere ai campi del file Clips.
     *
     * @param module il modulo in cui e' visibile il fatto
     * @param template il symbol con cui inizia il fatto ordinato a cui si e'
     * interessati
     * @return il resto del fatto, null se il fatto non esiste
     * @throws ClipsException
     */
    public String findOrderedFact(String module, String template) throws ClipsException {
        String eval = "(find-fact ((?f " + template + ")) TRUE)";
        MultifieldValue facts = (MultifieldValue) evaluate(module, eval);
        String result = "";
        try {
            if (facts.size() != 0) {
                String fatto = facts.get(0).toString();
                StringTokenizer st = new StringTokenizer(fatto, "<Fact- >");
                facts = (MultifieldValue) clips.eval("(fact-slot-value " + (new Integer(st.nextToken())) + " implied)");
                result = facts.get(0).toString();
                return result;
            }
        } catch (Exception ex) {
            this.throwException(ex);
        }
        return null;
    }

    /**
     * Equivalente alla funzione facts di Clips. Restituisce la lista dei facts
     * del modulo corrente.
     *
     * @return una stringa che rappresenta i facts del modulo corrente
     * @throws ClipsException
     */
    public String getFactList() throws ClipsException {
        router.startRec();
        PrimitiveValue fc = clips.eval("(get-focus)");
        String focus = fc.toString();
        String eval = "(facts)";
        evaluate(focus, eval);
        router.stopRec();
        return router.getStdout();
    }

    /**
     * Equivalente alla funzione agenda di Clips. Restituisce la lista delle
     * funzioni attualmente attivabili, in ordine di priorita' di attivazione.
     *
     * @return una stringa che rappresenta le azioni attivabili al momento
     * @throws ClipsException
     */
    public String getAgenda() throws ClipsException {
        router.startRec();
        PrimitiveValue fc = clips.eval("(get-focus)");
        String focus = fc.toString();
        String eval = "(agenda)";
        evaluate(focus, eval);
        router.stopRec();
        return router.getStdout();
    }

    /**
     * Inserisce una regola nell'ambiente clips caricato
     *
     * @param module il modulo su cui inserire la regola
     * @param rule la regola da inserire. Attenzione a scriverla bene in
     * linguaggio clips, perchè non sarà controllata.
     * @return true se non ci sono stati problemi, false altrimenti
     */
    public boolean defrule(String module, String rule) {
        PrimitiveValue val = evaluate(module, rule);
        if (val.toString().equalsIgnoreCase("FALSE")) {
            return false;
        } else {
            return true;
        }
    }
}
