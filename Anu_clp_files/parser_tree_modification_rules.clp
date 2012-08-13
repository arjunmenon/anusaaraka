 ; This file is written by Shirisha Manju (20-06-12)

 (defglobal ?*count*  = 0)

 ;======================================  Modifications for LWG and Order =========================================
 ; He wasted his golden opportunity to play in the national team. 
 ; Rename VP as Inf_VP   to avoid --- grouping VP and reversing VP
 (defrule rename_VP_for_To
 (declare (salience 30))
 ?f<-(Head-Level-Mother-Daughters to ?l ?VP ?TO ?VP1)
 ?f0<-(Node-Category ?VP VP)
 (Node-Category ?TO TO)
 ?f1<-(Node-Category ?VP1 VP)	
 ?f2<-(Head-Level-Mother-Daughters to ?l1 ?S $?a ?VP)
 (Head-Level-Mother-Daughters ?head ?lv $? ?S)
 (test (eq (member$ ?head (create$ had need are Are)) FALSE ))
 ?f3<-(Head-Level-Mother-Daughters ?h ?l2 ?VP1 $?d)
 =>
	(retract ?f ?f0 ?f1 ?f2 ?f3)	 
	(bind ?*count* (+ ?*count* 1))
	(bind ?toVP (explode$ (str-cat TO_VP ?*count* )))
	(bind ?infVP (explode$ (str-cat Inf_VP ?*count* )))
	(assert (Head-Level-Mother-Daughters to ?l ?toVP ?TO ?infVP)) 
	(assert (Head-Level-Mother-Daughters to ?l1 ?S $?a ?toVP))
	(assert (Head-Level-Mother-Daughters ?h ?l2 ?infVP $?d))
	(assert (Node-Category ?toVP  TO_VP))
	(assert (Node-Category ?infVP Inf_VP))
 )
 ;=======================================  Modifications for Pada  ===============================================
 ; Suggested by Chaitanya Sir
 ; Here we remark on two principal thrusts in physics: unification and reduction. 
 ; to make " two principal thrusts " as one pada
 (defrule remove_NX_node
 ?f0<-(Head-Level-Mother-Daughters ?h ?l ?Mot $?a ?NX)
 (Node-Category ?Mot NP)
 ?f<-(Node-Category ?NX NX)
 ?f1<-(Head-Level-Mother-Daughters ? ? ?NX $?d)
 =>
        (retract ?f ?f0 ?f1)
        (assert (Head-Level-Mother-Daughters ?h ?l ?Mot $?a $?d))
 )
 ;=======================================  Modifications for Order ===============================================

 ;In Kashmir, fishing is a good business and the ideal season is from April to October. 
 ;Suggested by Sukhada 
 (defrule from_to_PPs
 (declare (salience 10))
 ?f<-(Head-Level-Mother-Daughters ?head ?lvl ?Mot $?d1 ?PP1 ?PP2 $?d2)
 (Head-Level-Mother-Daughters from ? ?PP1 $?d3)
 (Head-Level-Mother-Daughters to ? ?PP2 $?d4)
 (Node-Category  ?PP1    PP)
 (Node-Category  ?PP2    PP)
 (not (Mother  ?PP1))
 =>
	(bind ?*count* (+ ?*count* 1))
        (retract ?f)
        (bind ?FromToPP (explode$ (str-cat FromToPP "c" ?*count* )))
        (assert (Head-Level-Mother-Daughters ?head ?lvl ?Mot $?d1  ?FromToPP $?d2))
        (assert (Head-Level-Mother-Daughters from ?lvl ?FromToPP ?PP1 ?PP2 ))
        (assert (Node-Category ?FromToPP FromToPP))
        (assert (Mother  ?PP1))
 )
 ;----------------------------------------------------------------------------------------------------------------
 ;Suggested by Sukhada
 ;October to March is the best time to visit the Jaipur city. Did you count ten to twelve.  
 ;In the south, jammu is a transition zone from the indian plains to the himalayas.
 ;Ten to twelve is easy to count.
 (defrule make_compoundPhrase
 ?f<-(Head-Level-Mother-Daughters ?head ?lvl ?Mot $?d1 ?NP ?PP $?d2)
 (Node-Category  ?NP    NP)
 (Node-Category  ?PP    PP)
 (Head-Level-Mother-Daughters ?h ? ?NP $?d3 )
 (parserid-word ?id ?h)
 (id-sd_cat ?id ?num1)
 (Head-Level-Mother-Daughters to ? ?PP $?d4 ?np)
 (Head-Level-Mother-Daughters ?h1 ? ?np $?d5)
 (parserid-word ?id1 ?h1)
 (id-sd_cat ?id1 ?num2)
 (test (and (eq (numberp ?h) FALSE) (eq (numberp ?h1) FALSE)))
 (test (or (and (neq (gdbm_lookup "time.gdbm" ?h) "FALSE")(neq (gdbm_lookup "time.gdbm" ?h1) "FALSE"))
          (and (neq (gdbm_lookup "place.gdbm" ?h) "FALSE")(neq (gdbm_lookup "place.gdbm" ?h1) "FALSE"))
          (and (eq ?num1 CD) (eq ?num2 CD)) ))
 (not (Mother  ?NP))
 =>
	(bind ?*count* (+ ?*count* 1))
        (retract ?f)
        (bind ?compPhrase (explode$ (str-cat COMP_PH ?*count* )))
        (assert (Mother  ?NP))
        (assert (Head-Level-Mother-Daughters ?head ?lvl ?Mot $?d1  ?compPhrase $?d2))
        (assert (Head-Level-Mother-Daughters ?h ?lvl ?compPhrase ?NP ?PP ))
        (assert (Node-Category ?compPhrase COMP_PH))
 )
 ;----------------------------------------------------------------------------------------------------------------
 ;;Is that the film in which he kills his mother? 
 ;Can you tell us where those strange ideas came from?
 (defrule convert_Q_sent_to_normal
 (declare (salience 10))
 ?f0<-(Head-Level-Mother-Daughters  ?head ?lev ?Mot ?vp ?np $?daut ?p)
 (Node-Category  ?p  P_DQ)
 (Node-Category  ?Mot  SQ)
 (Node-Category  ?vp   MD|VB|VBN|VBZ|VBD|VBP|VBG)
 (Head-Level-Mother-Daughters ?h ?l ?np $?d)
 (not (Mother  ?Mot))
 =>
        (retract ?f0)
        (bind ?*count* (+ ?*count* 1))
        (bind ?v (explode$ (str-cat "VPc" ?*count*)))
        (assert (Head-Level-Mother-Daughters ?head ?lev ?Mot ?np ?v ?p))
        (assert (Head-Level-Mother-Daughters ?head ?l ?v ?vp $?daut))
        (assert (Node-Category ?v VP))
        (assert (Mother  ?Mot))
 )
 ;----------------------------------------------------------------------------------------------------------------------- 
 ;Suggested by Sukhada
 ;What is the purpose of Dharma?
 (defrule convert_WH_Q_sent_to_normal
 ?f0<-(Head-Level-Mother-Daughters  ?head ?lev ?Mot ?vp ?np $?daut)
 (Node-Category  ?Mot  SQ)
 (Node-Category  ?vp   MD|VB|VBN|VBZ|VBD|VBP|VBG)
 (Head-Level-Mother-Daughters ?h ?l ?np $?d)
 (not (Mother  ?Mot))
 =>
        (retract ?f0)
	(bind ?*count* (+ ?*count* 1))
        (bind ?v (explode$ (str-cat "VPc" ?*count*)))
        (assert (Head-Level-Mother-Daughters ?head ?lev ?Mot ?np ?v))
        (assert (Head-Level-Mother-Daughters ?head ?l ?v ?vp $?daut))
        (assert (Node-Category ?v VP))
        (assert (Mother  ?Mot))
 )
 ;-----------------------------------------------------------------------------------------------------------------------