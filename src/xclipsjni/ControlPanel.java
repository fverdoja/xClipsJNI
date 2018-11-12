package xclipsjni;

import java.io.File;
import java.util.Observable;
import java.util.Observer;
import javax.swing.JFileChooser;
import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.filechooser.FileFilter;

/**Questa classe implementa il pannello di controllo di clips, questo modulo consente di svolgere tutte le azioni più utili,
 * fra cui: caricamento di un file clips, run, run(1) e run di un turno, visualizzazione agenda e visualizzazione fatti.
 * Questo pannello può essere integrato in un'interfaccia comprendente altre componenti, grazie al metodo getControlPanel(),
 * oppure può essere usato come finestra a se stante semplicemente attraverso il costruttore.
 *
 * @author Piovesan Luca, Verdoja Francesco
 */
class ControlPanel extends JFrame implements Observer {

	ClipsModel model;
	PropertyMonitor agendaMonitor;
	PropertyMonitor factsMonitor;

	/** Crea un nuovo Pannello di controllo per un ambiente clips
	 * 
	 * @param model il modello da controllare
	 */
	public ControlPanel(ClipsModel model) {
		initComponents();
		this.model = model;
		agendaMonitor = new PropertyMonitor("Agenda");
		factsMonitor = new PropertyMonitor("Fatti");
		this.model.addObserver((Observer) this);
	}

	/** Questo metodo è chiamato dal costruttore e inizializza il form
	 * WARNING: NON modificare assolutamente questo metodo.
	 */
	@SuppressWarnings("unchecked")
   // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
   private void initComponents() {

      controlPanel = new javax.swing.JPanel();
      loadFileButton = new javax.swing.JButton();
      loadFileLabel = new javax.swing.JLabel();
      separator = new javax.swing.JSeparator();
      runButton = new javax.swing.JButton();
      stepButton = new javax.swing.JButton();
      runOneButton = new javax.swing.JButton();
      visualizeLabel = new javax.swing.JLabel();
      visualizeAgendaButton = new javax.swing.JCheckBox();
      visualizeFactsButton = new javax.swing.JCheckBox();

      setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);
      setTitle("Pannello di Controllo");
      setMinimumSize(new java.awt.Dimension(375, 100));
      setName("panelFrame"); // NOI18N

      controlPanel.setMinimumSize(new java.awt.Dimension(375, 100));
      controlPanel.setPreferredSize(new java.awt.Dimension(388, 100));

      loadFileButton.setText("Carica Ambiente Clips");
      loadFileButton.addActionListener(new java.awt.event.ActionListener() {
         public void actionPerformed(java.awt.event.ActionEvent evt) {
            loadFileButtonActionPerformed(evt);
         }
      });

      loadFileLabel.setText("Nessun file caricato");
      loadFileLabel.setEnabled(false);

      runButton.setText("Run");
      runButton.setToolTipText("Esegue la Run di Clips");
      runButton.setEnabled(false);
      runButton.addActionListener(new java.awt.event.ActionListener() {
         public void actionPerformed(java.awt.event.ActionEvent evt) {
            runButtonActionPerformed(evt);
         }
      });

      stepButton.setText("Step");
      stepButton.setToolTipText("Esegue Run fino alla prossima azione del Robot");
      stepButton.setEnabled(false);
      stepButton.addActionListener(new java.awt.event.ActionListener() {
         public void actionPerformed(java.awt.event.ActionEvent evt) {
            stepButtonActionPerformed(evt);
         }
      });

      runOneButton.setText("Run(1)");
      runOneButton.setToolTipText("Esegue la Run(1) di Clips");
      runOneButton.setEnabled(false);
      runOneButton.addActionListener(new java.awt.event.ActionListener() {
         public void actionPerformed(java.awt.event.ActionEvent evt) {
            runOneButtonActionPerformed(evt);
         }
      });

      visualizeLabel.setHorizontalAlignment(javax.swing.SwingConstants.RIGHT);
      visualizeLabel.setText("Visualizza:");
      visualizeLabel.setEnabled(false);

      visualizeAgendaButton.setText("Agenda");
      visualizeAgendaButton.setEnabled(false);
      visualizeAgendaButton.addActionListener(new java.awt.event.ActionListener() {
         public void actionPerformed(java.awt.event.ActionEvent evt) {
            visualizeAgendaButtonActionPerformed(evt);
         }
      });

      visualizeFactsButton.setText("Fatti");
      visualizeFactsButton.setEnabled(false);
      visualizeFactsButton.addActionListener(new java.awt.event.ActionListener() {
         public void actionPerformed(java.awt.event.ActionEvent evt) {
            visualizeFactsButtonActionPerformed(evt);
         }
      });

      javax.swing.GroupLayout controlPanelLayout = new javax.swing.GroupLayout(controlPanel);
      controlPanel.setLayout(controlPanelLayout);
      controlPanelLayout.setHorizontalGroup(
         controlPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
         .addGroup(controlPanelLayout.createSequentialGroup()
            .addContainerGap()
            .addGroup(controlPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
               .addComponent(separator, javax.swing.GroupLayout.DEFAULT_SIZE, 351, Short.MAX_VALUE)
               .addGroup(controlPanelLayout.createSequentialGroup()
                  .addComponent(loadFileButton)
                  .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                  .addComponent(loadFileLabel, javax.swing.GroupLayout.DEFAULT_SIZE, 108, Short.MAX_VALUE)
                  .addGap(103, 103, 103))
               .addGroup(controlPanelLayout.createSequentialGroup()
                  .addComponent(runButton)
                  .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                  .addComponent(runOneButton)
                  .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                  .addComponent(stepButton)
                  .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                  .addComponent(visualizeLabel, javax.swing.GroupLayout.DEFAULT_SIZE, 79, Short.MAX_VALUE)
                  .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                  .addComponent(visualizeAgendaButton)
                  .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                  .addComponent(visualizeFactsButton)))
            .addContainerGap())
      );
      controlPanelLayout.setVerticalGroup(
         controlPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
         .addGroup(controlPanelLayout.createSequentialGroup()
            .addGap(16, 16, 16)
            .addGroup(controlPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
               .addComponent(loadFileButton)
               .addComponent(loadFileLabel))
            .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
            .addComponent(separator)
            .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
            .addGroup(controlPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE, false)
               .addComponent(runButton)
               .addComponent(runOneButton)
               .addComponent(stepButton)
               .addComponent(visualizeFactsButton)
               .addComponent(visualizeAgendaButton)
               .addComponent(visualizeLabel))
            .addGap(68, 68, 68))
      );

      javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
      getContentPane().setLayout(layout);
      layout.setHorizontalGroup(
         layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
         .addComponent(controlPanel, javax.swing.GroupLayout.PREFERRED_SIZE, 375, javax.swing.GroupLayout.PREFERRED_SIZE)
      );
      layout.setVerticalGroup(
         layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
         .addComponent(controlPanel, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
      );

      pack();
   }// </editor-fold>//GEN-END:initComponents

	/**azione eseguita quando si preme il bottone per il caricamento del file clips
	 * 
	 * @param evt l'evento scatenante l'azione
	 */
	private void loadFileButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_loadFileButtonActionPerformed
		final JFileChooser chooser = new JFileChooser(".");
		chooser.addChoosableFileFilter(new ClpFileFilter());
		int returnval = chooser.showDialog(null, "Carica Ambiente Clips");
		if (returnval == JFileChooser.APPROVE_OPTION) {
			File file = chooser.getSelectedFile();
			String path = file.getAbsolutePath();
			model.startCore(path);
			loadFileButton.setEnabled(false);
			loadFileLabel.setText(filename(path));
			loadFileLabel.setEnabled(true);
			runButton.setEnabled(true);
			stepButton.setEnabled(true);
			runOneButton.setEnabled(true);
			visualizeLabel.setEnabled(true);
			visualizeAgendaButton.setEnabled(true);
			visualizeFactsButton.setEnabled(true);
			model.execute();
		} else {
			throw new IllegalArgumentException("Incorrect file extension");
		}
	}//GEN-LAST:event_loadFileButtonActionPerformed

	/**azione eseguita quando si preme il checkbox per la visualizzazione dei fatti
	 * 
	 * @param evt l'evento scatenante l'azione
	 */
	private void visualizeFactsButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_visualizeFactsButtonActionPerformed
		factsMonitor.setVisible(visualizeFactsButton.isSelected());
	}//GEN-LAST:event_visualizeFactsButtonActionPerformed

	/**azione eseguita quando si preme il tasto Run
	 * 
	 * @param evt l'evento scatenante l'azione
	 */
	private void runButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_runButtonActionPerformed
		if (runButton.getText().equals("Run")) {
			model.setMode("RUN");
			model.resume();
			runButton.setText("Stop");
			stepButton.setEnabled(false);
			runOneButton.setEnabled(false);
		} else {
			model.setMode("STEP");
			runButton.setText("Run");
			stepButton.setEnabled(true);
			runOneButton.setEnabled(true);
		}
	}//GEN-LAST:event_runButtonActionPerformed

	/**azione eseguita quando si preme il tasto Step
	 * 
	 * @param evt l'evento scatenante l'azione
	 */
	private void stepButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_stepButtonActionPerformed
		model.setMode("STEP");
		model.resume();
	}//GEN-LAST:event_stepButtonActionPerformed

	/**azione eseguita quando si preme il checkbox per la visualizzazione dell'agenda
	 * 
	 * @param evt l'evento scatenante l'azione
	 */
	private void visualizeAgendaButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_visualizeAgendaButtonActionPerformed
		agendaMonitor.setVisible(visualizeAgendaButton.isSelected());
	}//GEN-LAST:event_visualizeAgendaButtonActionPerformed

	/**azione eseguita quando si preme il tasto Run(1)
	 * 
	 * @param evt l'evento scatenante l'azione
	 */
	private void runOneButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_runOneButtonActionPerformed
		model.setMode("RUNONE");
		model.resume();
	}//GEN-LAST:event_runOneButtonActionPerformed
   // Variables declaration - do not modify//GEN-BEGIN:variables
   private javax.swing.JPanel controlPanel;
   private javax.swing.JButton loadFileButton;
   private javax.swing.JLabel loadFileLabel;
   private javax.swing.JButton runButton;
   private javax.swing.JButton runOneButton;
   private javax.swing.JSeparator separator;
   private javax.swing.JButton stepButton;
   private javax.swing.JCheckBox visualizeAgendaButton;
   private javax.swing.JCheckBox visualizeFactsButton;
   private javax.swing.JLabel visualizeLabel;
   // End of variables declaration//GEN-END:variables

	/**Metodo per ottenere un'istanza del pannello di controllo
	 * 
	 * @return il pannello di controllo racchiuso in un JPanel
	 */
	public JPanel getControlPanel() {
		return controlPanel;
	}

	@Override
	public void update(Observable o, Object o1) {
		try {
			if (agendaMonitor.isVisible()) {
				agendaMonitor.setText(model.getAgenda());
			} else {
				visualizeAgendaButton.setSelected(false);
			}
			if (factsMonitor.isVisible()) {
				factsMonitor.setText(model.getFactList());
			} else {
				visualizeFactsButton.setSelected(false);
			}
		} catch (Exception ex) {
			System.out.println("[ERRORE] " + ex.toString());
		}
	}

	/**Estrae il nome di un file (con l'estensione) da un path.
	 * 
	 * @param path un path ad un file
	 * @return una stringa contenente solo il nome del file
	 */
	static private String filename(String path) {
		int i = path.lastIndexOf(File.separator);
		return path.substring(i + 1, path.length());
	}

	private class ClpFileFilter extends FileFilter {

		@Override
		public boolean accept(File f) {
			if (f.isDirectory()) {
				return true;
			}
			String ext = null;
			String s = f.getName();
			int i = s.lastIndexOf('.');

			if (i > 0 && i < s.length() - 1) {
				ext = s.substring(i + 1).toLowerCase();
			}
			if (ext.equalsIgnoreCase("clp")) {
				return true;
			}
			return false;
		}

		@Override
		public String getDescription() {
			return "Clips files";
		}
	}
}
