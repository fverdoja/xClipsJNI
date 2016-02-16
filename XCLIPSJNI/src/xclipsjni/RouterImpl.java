package xclipsjni;

import net.sf.clipsrules.jni.Router;

/**L'implementazione della classe Router
 *
 * @author Piovesan Luca, Verdoja Francesco
 */
public class RouterImpl implements Router {

    private String theName;
    private int thePriority;
    private boolean ungotten;
    private int lastChar;

    public RouterImpl(String name) {
        this(name, 10);
    }

    public RouterImpl(String name, int priority) {
        super();
        theName = name;
        thePriority = priority;
        ungotten = false;
    }

    @Override
    public int getPriority() {
        return thePriority;
    }

    @Override
    public String getName() {
        return theName;
    }

    @Override
    public boolean query(String routerName) {
        if (routerName.equals("stdout")
                || routerName.equals("stdin")
                || routerName.equals("wwarning")
                || routerName.equals("werror")
                || routerName.equals("wtrace")
                || routerName.equals("wdialog")
                || routerName.equals("wclips")
                || routerName.equals("wdisplay")) {
            return true;
        }

        return false;
    }

    @Override
    public void print(String routerName, String printString) {
        System.out.print(printString);
    }

    @Override
    public int getchar(String routerName) {
        int rv = -1;

        if (ungotten) {
            ungotten = false;
            return lastChar;
        }

        try {
            rv = System.in.read();
        } catch (Exception e) {
            e.printStackTrace(System.err);
        }

        return rv;
    }

    @Override
    public int ungetchar(String routerName, int theChar) {
        if (ungotten) {
            return -1;
        }

        lastChar = theChar;
        ungotten = true;

        return theChar;
    }

    @Override
    public boolean exit(int exitCode) {
        return true;
    }
}