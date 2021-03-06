(defglobal ?*pn_file* = pf)
(defglobal ?*m_pn_file* = mpf)
(defglobal ?*d_file* = df)

(deftemplate manual_word_info (slot head_id (default 0))(multislot word (default 0))(multislot word_components (default 0))(multislot root (default 0))(multislot root_components (default 0))(multislot vibakthi (default 0))(multislot vibakthi_components (default 0))(slot tam (default 0))(multislot tam_components (default 0))(multislot group_ids (default 0)))

;(deftemplate manual_word_info (slot head_id (default 0))(multislot word (default 0))(multislot word_components (default 0))(multislot root (default 0))(multislot root_components (default 0))(multislot vibakthi (default 0))(multislot vibakthi_components (default 0))(multislot group_ids (default 0)))

(deftemplate tam_database_info (multislot e_tam (default 0)) (slot database_name (default 0)) (multislot meaning (default 0))(multislot components (default 0)))
(deftemplate  database_info (slot root (default 0))(slot meaning (default 0))(multislot components (default 0))(slot database_name (default 0))( slot database_type (default 0))(multislot group_ids (default 0)))



(deffunction remove_character(?char ?str ?replace_char)
                        (bind ?new_str "")
                        (bind ?index (str-index ?char ?str))
                        (if (neq ?index FALSE) then
                        (while (neq ?index FALSE)
                        (bind ?new_str (str-cat ?new_str (sub-string 1 (- ?index 1) ?str) ?replace_char))
                        (bind ?str (sub-string (+ ?index 1) (length ?str) ?str))
                        (bind ?index (str-index ?char ?str))
                        )
                        )
                (bind ?new_str (explode$ (str-cat ?new_str (sub-string 1 (length ?str) ?str))))
)


(defrule del_PropN_tag_in_hi_mng
(declare (salience 2001))
?f0<-(id-HM-source ?id PropN $?mng PropN ?s)
=>
        (retract ?f0)
        (assert (id-HM-source ?id $?mng ?s))
)

(defrule del_symbols
?f0<-(anu_id-anu_mng-sep-man_id-man_mng_tmp $?a @SYMBOL-@GREATERTHAN@SYMBOL-@GREATERTHAN|@SYMBOL-@LESSTHAN@SYMBOL-@LESSTHAN $?b)
=>
	(retract ?f0)
	(assert (anu_id-anu_mng-sep-man_id-man_mng_tmp $?a $?b))
)

;------------------------------------- get multiple proper noun list ---------------------------
(defrule get_mul_proper_n_list
(declare (salience 15))
(left_over_ids)
(anu_id-anu_mng-sep-man_id-man_mng_tmp ?id ? $?  - ?mid $?)
?f<-(id-cat_coarse ?id PropN)
(or (id-cat_coarse ?id1&:(= (- ?id 1) ?id1) PropN)(id-cat_coarse ?id1&:(= (+ ?id 1) ?id1) PropN))
?f1<-(proper_noun_ids $?ids)
(id-right_punctuation  ?id	?p&~PUNCT-Colon)
(not (got_group))
(not (anu_id-anu_mng-sep-man_id-man_mng_tmp ?id1 $?))
=>
        (retract ?f ?f1)
        (bind $?ids (sort > (create$ $?ids ?id ?id1)))
        (assert (proper_noun_ids ?id $?ids))
        (assert (got_group))
)

(defrule get_mul_proper_n_list1
?f1<-(proper_noun_ids ?h ?id $?d1)
(test (neq (numberp ?id) FALSE))
?f<-(id-cat_coarse ?id1&:(= (- ?id 1) ?id1) PropN)
(not (anu_id-anu_mng-sep-man_id-man_mng_tmp ?id1 $?))
=>
        (retract ?f1 ?f)
        (bind $?ids (sort > (create$ ?id $?d1 ?id1)))
        (assert (proper_noun_ids ?h $?ids))
)

(defrule get_mul_proper_n_list2
?f1<-(proper_noun_ids ?h $?ids ?id)
(test (neq (numberp ?id) FALSE))
?f<-(id-cat_coarse ?id1&:(= (+ ?id 1) ?id1) PropN)
(not (anu_id-anu_mng-sep-man_id-man_mng_tmp ?id1 $?))
=>
        (retract ?f1 ?f)
        (bind $?ids (sort > (create$ $?ids ?id ?id1)))
        (assert (proper_noun_ids ?h $?ids))
)

(defrule substitute_words
(declare (salience 10))
?f<-(proper_noun_ids ?h $?p ?id $?p1)
(id-original_word  ?id ?word)
=>
        (retract ?f)
        (assert (proper_noun_ids ?h $?p ?word $?p1))
)

(defrule get_multi_PropN_mng
(declare (salience 5))
?f0<-(proper_noun_ids ?h $?eng)
(anu_id-anu_mng-sep-man_id-man_mng_tmp ?h ?word $?  - ?mid $?)
(manual_word_info (head_id ?mid) (word $?mmng))
=>
	(retract ?f0)
	(bind ?pn (remove_character " " (implode$ (create$  $?eng)) "_"))
	(printout ?*m_pn_file* (implode$ ?pn)"	"(implode$ $?mmng) crlf)
)

(defrule get_multi_PropN_mng1
(declare (salience 4))
(anu_id-anu_mng-sep-man_id-man_mng_tmp ?aid $?a - ?mid $?)
?f<-(id-cat_coarse ?aid PropN)
?f1<-(id-cat_coarse ?aid1&:(= (+ ?aid 1) ?aid1) PropN)
(anu_id-anu_mng-sep-man_id-man_mng_tmp ?aid1 $?a1 - ?mid1 $?)
(id-original_word  ?aid ?word)
(id-original_word  ?aid1 ?word1)
(manual_id-word ?mid ?m)
(manual_id-word ?mid1 ?m1)
=>
	(retract ?f ?f1)
	(printout ?*m_pn_file* ?word"_"?word1"	"?m" "?m1 crlf)
)  

;------------------------------ get proper noun mng list ----------------------------
(defrule get_word_mng
(declare (salience 2))
(left_over_ids)
(anu_id-anu_mng-sep-man_id-man_mng_tmp ?aid ?word $?  - ?mid $?)
(manual_word_info (head_id ?mid) (word $?mmng)) 
(id-word ?aid ?word1)
(id-original_word ?aid ?word)
?f0<-(id-cat_coarse ?aid ?cat)
=>
	(retract ?f0)
	(if (eq ?cat PropN) then
		(printout ?*pn_file* ?word"	" ?word1"	" (implode$ $?mmng) crlf)
	else
		(printout ?*pn_file* ?word"	" ?word"	" (implode$ $?mmng) crlf)
	)	
)	

(defrule get_mng_for_trans
(declare (salience 2))
(left_over_ids)
(anu_id-anu_mng-sep-man_id-man_mng_tmp ?aid ? $?  - ?mid $?)
(manual_word_info (head_id ?mid) (word $?mmng))           
(id-HM-source ?aid $?mng transliterate_mng)
(id-word ?aid ?word)
?f0<-(id-cat_coarse ?aid ?cat)
=>
	(retract ?f0)
	(printout ?*pn_file* ?word"	" (implode$ $?mng) "	" (implode$ $?mmng) crlf)
)

(defrule get_PropN_mng
(left_over_ids)
(anu_id-anu_mng-sep-man_id-man_mng_tmp ?aid $?amng ?am  - ?mid $?)
(manual_word_info (head_id ?mid) (word $?mmng)) 
?f0<-(id-cat_coarse ?aid PropN)
(id-word ?aid ?word)
=>
	(retract ?f0)
	(if (member$ ?am (create$ ko ke kI kA ne se meM waka)) then
		(bind $?n_amng $?amng)
	else
		(bind $?n_amng $?amng ?am)
	)
	(if (neq $?mmng $?n_amng) then
		(printout ?*pn_file* ?word"	" (implode$ $?n_amng) "	" (implode$ $?mmng) crlf)
	)
)

(defrule get_dic_mng
(declare (salience -1))
(left_over_ids)
?f0<-(anu_id-anu_mng-sep-man_id-man_mng_tmp ?aid $?amng - ?mid ?mng)
(id-root ?aid ?root)
(man_word-root-cat ?mng ?mroot ?)
(not (database_info (meaning ?mroot) (database_name default-iit-bombay-shabdanjali-dic_smt.gdbm|transliterate_meaning.gdbm|provisional_transliterate_mng.gdbm) (group_ids ?aid)))
(id-cat_coarse ?aid ?cat)
(id-word ?aid ?word)
=>
	(retract ?f0)
	(assert (word-root-cat-mng   ?word ?root ?cat ?mroot))
;	(printout ?*d_file* ?root"_"?cat"	"?mroot crlf)
)

(defrule print_sen
(declare (salience -2))
(word-root-cat-mng $?)
(para_id-sent_id-no_of_words ? ?senid ?)
(Eng_sen $?sen)
(manual_hin_sen $?m)
(not (got sen))	
=>
	(printout ?*d_file* ?senid "  Eng: " (implode$ $?sen) crlf)
	(printout ?*d_file* "   Hin: " (implode$ $?m) crlf)
	(assert (got sen))	
	
)

(defrule print_info
(got sen)	
?f0<-(word-root-cat-mng ?w ?r ?c ?mr)
=>
	(retract ?f0)
	(printout ?*d_file* "	"?w "	"?r"_"?c"	"?mr crlf)
)

(defrule print_info1
(declare (salience -20))
(got sen)
=>
	(printout ?*d_file* "----------------------------------------------------" crlf crlf)
)

