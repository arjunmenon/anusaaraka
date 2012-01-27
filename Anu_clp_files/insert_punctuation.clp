 (deftemplate pada_info (slot group_head_id (default 0))(slot group_cat (default 0))(multislot group_ids (default 0))(slot vibakthi (default 0))(slot gender (default 0))(slot number (default 0))(slot case (default 0))(slot person (default 0))(slot H_tam (default 0))(slot tam_source (default 0))(slot preceeding_part_of_verb (default 0)) (multislot preposition (default 0))(slot Hin_position (default 0))(slot pada_head (default 0)))
 
 ;Added by Shirisha Manju 
 ;A slow, balmy breeze from the south engulfed everyone in the audience. No, it was not Black Monday.
 ;The main states of southern india are tamilnadu, kerala, maharashtra, andhrapradesh and karnataka.
 (defrule punct_info_for_JJ
 (declare (salience 1150))
 (or (mother-punct_head-right_punctuation ?mot ?p_h ?punct&~P_DOT)(mother-punct_head-punctuation ?mot ?p_h ?punct&~P_DOT))
 (Node-Category  ?mot  JJ|UH|NN|NNP|PP|ADVP)
 (Head-Level-Mother-Daughters ? ? ?mot ?id)
 ?f0<-(hindi_id_order $?pre ?id $?post)
 (not (punc_inserted ?p_h))
 =>
        (retract ?f0)
        (assert (hindi_id_order $?pre ?id ?punct $?post))
	(assert (id-left_punct-right_punct ?id - ?punct))
        (assert (punc_inserted ?p_h))
 )
 ;---------------------------------------------------------------------------------------------------------------
 ;Added by Shirisha Manju 
 ; During the 'state of siege', political opponents were imprisoned (and many of them 'disappeared'), censorship was systematic and all non-government political activity banned. 
 (defrule left_punct_for_JJ
 (declare (salience 1150))
 (mother-punct_head-left_punctuation  ?mot ?p_h ?punct&~P_DOT)
 (Node-Category  ?mot  JJ|UH|NN|NNP|PP|ADVP)
 (Head-Level-Mother-Daughters ? ? ?mot ?id)
 ?f0<-(hindi_id_order $?pre ?id $?post)
 (not (punc_inserted ?p_h))
 =>
        (retract ?f0)
        (assert (hindi_id_order $?pre ?punct ?id $?post))
        (assert (id-left_punct-right_punct ?id ?punct -))
        (assert (punc_inserted ?p_h))
 )
 ;---------------------------------------------------------------------------------------------------------------
 ;Added by Shirisha Manju 
 ;Allahabad is also known for its annual magh mela (mini kumbh mela) and colorful dussehra festival.
 ;He said such results should be "measurable in dollars and cents" in reducing the U.S. trade deficit with Japan. 
 (defrule substitute_left_paren
 (declare (salience 1150))
 (mother-punct_head-left_punctuation ?mot ?p_h ?punct)
 (Node-Category  ?p_h P_LB|P_DQT)
 (Head-Level-Mother-Daughters ? ? ?mot ?id $?)
 ?f0<-(hindi_id_order $?pre ?id $?post)
 (not (punc_inserted ?p_h))
 =>
        (retract ?f0)
        (assert (hindi_id_order $?pre ?punct ?id $?post))
	(assert (id-left_punct-right_punct ?id ?punct -))
        (assert (punc_inserted ?p_h))
 )
 ;---------------------------------------------------------------------------------------------------------------
 ;Added by Shirisha Manju 
 ;A big, black, ugly dog chased me. From your description, I do not think I would enjoy it. No, it was not Black Monday.
 ;He neither plays, nor reads.Allahabad is also known for its annual magh mela (mini kumbh mela) and colorful dussehra festival.He said such results should be "measurable in dollars and cents" in reducing the U.S. trade deficit with Japan. 
 ;"We have been very disappointed in the performance of natural gas prices," said Mr. Cox, Phillips's president. 
 (defrule get_phrase_group
 (declare (salience 1100))
 (or (mother-punct_head-punctuation ?PP ? ?punc&~P_DQ&~P_DOT)(mother-punct_head-right_punctuation ?PP ? ?punc&~P_DQ&~P_DOT)(mother-punct_head-left_punctuation ?PP ? ?punc&~P_DQ&~P_DOT))
 ?f1<-(Head-Level-Mother-Daughters ?h ?l ?PP $?d ?JJ $?d1)
 (Node-Category  ?PP  ADJP|PP|NP|ADVP|INTJ|VP)
 (Node-Category  ?JJ  JJ|IN|PRP$|NN|RB|UH|VBZ|PP|NNS|CC|NNP|RP|NP|CD) 
?f0<-(Head-Level-Mother-Daughters ? ? ?JJ $?prep)
 =>
        (retract ?f0 ?f1)
        (assert (Head-Level-Mother-Daughters ?h ?l ?PP $?d $?prep $?d1))
 )
 ;---------------------------------------------------------------------------------------------------------------
 ;Added by Shirisha Manju (26-01-12)
 ;Says Mr. Mosettig: CNN is my wire service; they are on top of everything.
 (defrule punc_for_S_grp1
 (declare (salience 1150))
 (mother-punct_head-punctuation ?Mot ?p_h ?punc&~P_DQ&~P_DOT)
 (Node-Category  ?Mot  S)
 (Head-Level-Mother-Daughters ?h ?l ?Mot $?d ?VP)
 (Head-Level-Mother-Daughters ?h1 ?l1 ?VP $?d1 ?VP1)
 (Node-Category  ?VP1  VBZ)
 (Head-Level-Mother-Daughters ? ? ?VP1 ?id)
 ?f0<-(hindi_id_order $?pre ?id $?post)
 (not (punc_inserted ?p_h))
 =>
        (retract ?f0)
        (assert (hindi_id_order $?pre ?id ?punc $?post))
        (assert (id-left_punct-right_punct ?id - ?punc))
        (assert (punc_inserted ?p_h))
 )
 ;---------------------------------------------------------------------------------------------------------------
 ; Added by Shirisha Manju (23-01-12)
 ;I did not think he would do it, but he did. 
 (defrule punc_for_S_grp
 (declare (salience 1150))
 (mother-punct_head-punctuation ?Mot ?p_h ?punc&~P_DQ&~P_DOT)
 ?f1<-(Head-Level-Mother-Daughters ?h ?l ?Mot $?d ?id $?d1)
 (Node-Category  ?Mot  S)
 ?f2<-(Head-Level-Mother-Daughters ?h1 ?l1 ?Sbar $?d1)
 (Node-Category  ?Sbar  SBAR)
 ?f0<-(hindi_id_order $?pre ?id $?post)
 (not (punc_inserted ?p_h))
 =>
        (retract ?f0)
        (assert (hindi_id_order $?pre ?id ?punc $?post))
	(assert (id-left_punct-right_punct ?id - ?punc))
        (assert (punc_inserted ?p_h))
 )
 ;---------------------------------------------------------------------------------------------------------------
 ;Added by Shirisha Manju 
 ;From your description, I do not think I would enjoy it.
 (defrule punc_for_PP_grp
 (declare (salience 1000))
 (mother-punct_head-punctuation ?Mot ?p_h ?punc&~P_DQ&~P_DOT)
 (Node-Category  ?Mot  PP)
 ?f1<-(Head-Level-Mother-Daughters ?h ?l ?Mot $?d ?id ?prep)
 ?f0<-(hindi_id_order $?pre ?id $?post)
 (not (punc_inserted ?p_h))
 =>
        (retract ?f0)
        (assert (hindi_id_order $?pre ?id ?punc $?post))
	(assert (id-left_punct-right_punct ?id - ?punc))
        (assert (punc_inserted ?p_h))
 )
 ;---------------------------------------------------------------------------------------------------------------
 ;Added by Shirisha Manju
 ;If John was with Lisa last night, who went to the movie with Diane. 
 ;He said such results should be "measurable in dollars and cents" in reducing the U.S. trade deficit with Japan. 
 (defrule substitute_punc_for_sbar
 (declare (salience 1000)) 
 (or (mother-punct_head-punctuation ?Mot ?p_h ?punc&~P_DQ&~P_DOT)(mother-punct_head-right_punctuation ?Mot ?p_h ?punc))
 (Head-Level-Mother-Daughters ? ? ?Mot $?d)
 (Head-Level-Mother-Daughters ? ? ?FRAG $? $?d $? ?id)
 (Node-Category  ?FRAG FRAG|SBAR)
 ?f0<-(hindi_id_order $?pre ?id $?post)
 (not (punc_inserted ?p_h))
 =>
        (retract ?f0)
        (assert (hindi_id_order $?pre ?id ?punc $?post))
	(assert (id-left_punct-right_punct ?id - ?punc))
        (assert (punc_inserted ?p_h))
 )
 ;---------------------------------------------------------------------------------------------------------------
 ; Added by Shirisha Manju
 ;I ate fruits, drank milk and slept.
 (defrule substitute_punc_info
 (declare (salience 700))
 (or (mother-punct_head-punctuation ?Mot ?p_h ?punc&~P_DQ&~P_DOT)(mother-punct_head-right_punctuation ?Mot ?p_h ?punc))
 (Head-Level-Mother-Daughters ?h ?l  ?Mot $?d ?id)
 ?f0<-(hindi_id_order $?pre ?id $?post)
 (not (punc_inserted ?p_h))
 =>
        (retract ?f0)
        (assert (hindi_id_order $?pre ?id ?punc $?post))
	(assert (id-left_punct-right_punct ?id - ?punc))
        (assert (punc_inserted ?p_h))
 )
 ;---------------------------------------------------------------------------------------------------------------
