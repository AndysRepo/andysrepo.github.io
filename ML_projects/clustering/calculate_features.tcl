set outfile1 [open "rmsd.txt" w]
set outfile2 [open "rog.txt" w]
set outfile3 [open "sasa.txt" w]

mol new ./apo_GLUCO.pdb type pdb


set mol [mol new apo_GLUCO.pdb type pdb waitfor all]
mol addfile bemeta_500frames.dcd type dcd  first 0 last 500  skip 1 waitfor all

set protein_compare [atomselect 1 "protein and name CA"]
set protein_reference [atomselect 0 "protein and name CA"]
set BS [atomselect 1 "protein and resid 18 188 189 191 195 213 214 237 238 240 269 272 and noh"]
set pdbselection [atomselect 1 "all"]

                set num_steps [molinfo $mol get numframes]
                for {set frame 1} {$frame < $num_steps} {incr frame} {
                        $protein_compare frame $frame
                        animate goto $frame
                        set trans_mat [measure fit $protein_compare $protein_reference]
                        $pdbselection move $trans_mat
                        set rmsd [measure rmsd $protein_compare $protein_reference]
                        set rog [measure rgyr $BS]
		        set sasa [measure sasa 1 $BS]
                        puts $outfile1 "$frame $rmsd"
                        puts $outfile2 "$frame $rog"
		        puts $outfile3 "$frame $sasa"
               }
       close $outfile1
       close $outfile2
       close $outfile3