(deftemplate pada_info (slot group_head_id (default 0))(slot group_cat (default 0))(multislot group_ids (default 0))(slot vibakthi (default 0))(slot gender (default 0))(slot number (default 0))(slot case (default 0))(slot person (default 0))(slot H_tam (default 0))(slot tam_source (default 0))(slot preceeding_part_of_verb (default 0)) (multislot preposition (default 0))(slot Hin_position (default 0))(slot pada_head (default 0)))

;============================================ Defining  Deffunctions ======================================================
 (deffunction print_head_info ()
 (printout fp "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" crlf)
 (printout fp "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"\">" crlf)
 (printout fp "<html xmlns=\"http://www.w3.org/1999/xhtml\">" crlf)
 (printout fp "<head>" crlf)
 (printout fp "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" />" crlf)
 (printout fp "<link href=\"style.css\" type=\"text/css\" rel=\"stylesheet\" />" crlf)
 (printout fp "<link href=\"hindi_alignment.css\" type=\"text/css\" rel=\"stylesheet\" />" crlf)
 (printout fp "<script src=\"script.js\" type=\"text/javascript\"></script>" crlf)
 (printout fp "<script src=\"open.js\" type=\"text/javascript\"></script>" crlf)
 (printout fp "<script src=\"hindi_alignment.js\" type=\"text/javascript\"></script>" crlf)
 (printout fp "<title>anusAraka alignment</title>" crlf)
 (printout fp "</head>" crlf)
 (printout fp "<body onload=\"register_keys()\">" crlf)
 (printout fp "<div id=\"navigation\">" crlf)
 (printout fp "<form action=\"\" onsubmit=\"goto_section(); return false;\">" crlf)
 (printout fp "<p><a id=\"english_order\" href=\""?*filename*".html\" target=\"_new\">Layered Output [English-order]</a><a id=\"translation\" href=\""?*filename*"_trnsltn.html\" target=\"_new\"> Translation </a><a id=\"help\" href=\"help.html\" target=\"_new\">Help</a><input type=\"text\" name=\"goto_section_value\" size=\"5\" /><input type=\"button\" value=\"Goto\" onclick=\"goto_section()\" /><input type=\"hidden\" name=\"no_of_rows\" value=\"3\" /><input type=\"button\" value=\"Show/Hide Rows...\" onclick=\"window.open('rows.html','ShowHideRowsWindow','top=200,left=200,height=500,width=300,location=no,menubar=no,toolbar=no,directories=no,statusbar=no');\" /><input type=\"checkbox\" name=\"numbers_value\" checked=\"checked\" onchange=\"toggle_numbers()\" />Numbers<input type=\"checkbox\" name=\"border_value\" checked=\"checked\" onchange=\"toggle_borders()\" />Borders</p>" crlf)
 (printout fp "</form>" crlf)
 (printout fp "</div>" crlf)
 (printout fp "<div class=\"float_clear\"/>" crlf crlf)
 )

;-------------------------------------------------------------------------------------------------
 
 (deffunction print_anu_eng_row(?p_id ?s_id ?w_id ?chnk_fr_htm ?anu_eng)
 (if (= ?w_id 1) then (printout fp "<form class=\"suggestion\" action=\"sumbit_suggestions.php\">" crlf))
 (printout fp "<table cellspacing=\"0\">"crlf"<tr class=\"row1\">" crlf)
 (if (= ?w_id 1) then (printout fp "<td class=\"number\">"?p_id"."?s_id".A</td>"))
 (printout fp "<td class=\""?chnk_fr_htm"\">" ?anu_eng "</td>"crlf"</tr>" crlf)
 )

;-------------------------------------------------------------------------------------------------
 
 (deffunction print_anu_tran_row(?p_id ?s_id ?w_id ?chnk_fr_htm ?anu_op)
 (if (= ?w_id 1) then (printout fp "<form class=\"suggestion\" action=\"sumbit_suggestions.php\">" crlf))
 (printout fp "<tr class=\"row2\">" crlf )
 (if (= ?w_id 1) then (printout fp "<td class=\"number\">"?p_id"."?s_id".B</td>"))
 (printout fp "<td class=\""?chnk_fr_htm"\">" ?anu_op "</td>"crlf"</tr>" crlf)
 )

;-------------------------------------------------------------------------------------------------

 (deffunction print_man_tran_row(?p_id ?s_id ?w_id ?chnk_fr_htm ?man_op)
 (if (= ?w_id 1) then (printout fp "<form class=\"suggestion\" action=\"sumbit_suggestions.php\">" crlf))
 (printout fp "<tr class=\"row3\">" crlf )
 (if (= ?w_id 1) then
 (printout fp "<td class=\"number\">"?p_id"."?s_id".C</td>"))
 (printout fp "<td class=\""?chnk_fr_htm"\"> " ?man_op " </td>" crlf "</tr>" crlf)
 )

;-------------------------------------------------------------------------------------------------

 (deffunction print_suggestion_row(?p_id ?s_id ?w_id ?chnk_fr_htm ?man_op)
 (printout fp "<tr class=\"row4\">" crlf )
 (if (= ?w_id 1) then (printout fp "<td class=\"number\">&nbsp;</td>"))
 (printout fp "<td class=\""?chnk_fr_htm"\"><input name=\"suggestion_1.1\" type=\"text\" class=\"suggestion\" size=\"1\" value=\"")
 (printout fp ?man_op"\" /></td></tr>" crlf)
 (printout fp "</table>" crlf)
 )
 
;============================= Asserting control facts and modifying the original facts ====================================

 (defrule replace_spc_with_underscore
 (declare (salience 6000))
 ?f<-(anu_id-anu_mng-sep-man_id-man_mng ?id $?anu_grp_mng - ?id $?man_grp_mng)
 (test (numberp ?id))
 =>
 (retract ?f)
 (loop-for-count (?i 1 (length $?anu_grp_mng))
                 (bind ?str (nth$ ?i $?anu_grp_mng))
                 (if (not (numberp ?str)) then (bind ?str (wx_utf8 ?str)))
                 (if (eq ?i 1) then
                 (bind ?anu_gp_mng ?str)
                 else
                 (bind ?anu_gp_mng (str-cat  ?anu_gp_mng "_" ?str))))
 (loop-for-count (?i 1 (length $?man_grp_mng))
                 (bind ?str (nth$ ?i $?man_grp_mng))
                 (if (not (numberp ?str)) then (bind ?str (wx_utf8 ?str)))
                 (if (eq ?i 1) then
                 (bind ?man_gp_mng ?str)
                 else
                 (bind ?man_gp_mng (str-cat  ?man_gp_mng "_" ?str))))
 (if (= (length $?man_grp_mng) 0) then (bind ?man_gp_mng "-"))
 (if (= (length $?anu_grp_mng) 0) then (bind ?anu_gp_mng "-"))
 (assert (anu_id-anu_mng-man_id-man_mng ?id ?anu_gp_mng ?id ?man_gp_mng))
 )

 ;convert Apertium_output wx notation to utf8.
 (defrule convert_wx_to_utf8
 (declare (salience 5999))
 ?f<-(hin_pos-hin_mng-eng_ids-eng_words ?id ?hin $?grp ?id1 ?eng)
 (not (id_wx_to_utf_converted ?id))
 (test (and (neq ?hin -D-) (neq ?hin -U-)))
 =>
 (retract ?f)
        (if (not (numberp ?hin)) then (bind ?hin (wx_utf8 ?hin))
        (if (eq (sub-string 1 2 ?hin) "\\@") then (bind ?hin (str-cat (sub-string 3 1000 ?hin)))))
        (assert (hin_pos-hin_mng-eng_ids-eng_words ?id ?hin $?grp ?id1 ?eng))
        (assert (id_wx_to_utf_converted ?id))
 )
 ;---------------------------------------------------------------------------------------------------

 
 (defrule cntrl_fact_for_chunk
 (declare (salience 6000))
 (id-word ?id ?word)
 (not (chunk_cntrl_fact ?id))
 ?f<-(chunk-ids ?chunk_type $?ids)
 (test (member$ ?id $?ids))
  =>
 (assert (chunk_cntrl_fact ?id))
 )

;-------------------------------------------------------------------------------------------------
 ; Asserting default chunk if not present
 (defrule test_for_chunk
 (declare (salience 5900))
 (id-original_word ?id ?word)
 (not (chunk_cntrl_fact ?id))
 =>
 (assert (chunk-ids U ?id)))

;-------------------------------------------------------------------------------------------------
 ;Adding new field "?chnk_type" to all chunk facts
 (defrule modify_chunk_fct_for_html
 (declare (salience 5800))
 ?f<-(chunk-ids ?chnk_type $?ids ?id)
 (not (chunk_cntrl_fact_for_html ?id))
 =>
 (retract ?f)
 (assert (chunk-ids ?chnk_type ?chnk_type $?ids ?id))
 (assert (chunk_cntrl_fact_for_html ?id))
 )

;-------------------------------------------------------------------------------------------------
 ;Modifying  the chunk color of the second chunk if there are two consecutive same chunks
 (defrule change_chunk_consecutive_same_color
 (declare (salience 5700))
 (chunk-ids ?chnk_type ?chnk $?ch1 ?id)
 ?f1<-(chunk-ids ?chnk_type ?chnk ?id1 $?ch2)
 (test (and (numberp ?id) (numberp ?id1)))
 (test (and (neq ?chnk REP)(= ?id1 (+ ?id 1))))
 =>
 (retract ?f1)
 (assert (chunk-ids ?chnk_type REP ?id1 $?ch2)))

;============================== Printing to  html file  ===================================================================

 ;Printing html head information 
 (defrule print_head_info_to_html
 (declare (salience 5002))
 (para_id-sent_id-no_of_words 1 1 ?n_words)
 (not (printed_head_info))
 =>
 (print_head_info)
 (assert(printed_head_info)))
 
;--------------------------------------------------------------------------------------------
 ;Asserting a fact (id-len) 
 ;id here is ==> hindi position and len ==> length of the hindi order
 (defrule sen_first_word
 (declare (salience 5001))
 (hindi_order_length ?len)
 =>
 (assert (id-len 1 ?len));here hindi position starts from 1 , as it moves through the rules position gets increased and length gets decreased and finally when length=0 it fires sent_end rule and moves to next sentence.
 )

;--------------------------------------------------------------------------------------------
 ;Printing to html file
 (defrule print_to_html
 (declare (salience 4900))
 (para_id-sent_id-no_of_words ?p_id ?s_id ?n_words)
 ?f<-(id-len ?id ?len)
 (hin_pos-hin_mng-eng_ids-eng_words ?id ?hin_mng $?eng_ids ?eng)
 (anu_id-anu_mng-man_id-man_mng ?id1 ?anu_mng ?mid ?man_mng)
 (test (member$ ?id1 $?eng_ids))
 (chunk-ids ?chunk_type ?chnk_fr_htm $?ids)
 (test (member$ (nth$ (length $?eng_ids) $?eng_ids) $?ids))
 =>
         (retract ?f)
         (print_anu_eng_row  ?p_id ?s_id ?id ?chnk_fr_htm ?eng)
         (print_anu_tran_row  ?p_id ?s_id ?id ?chnk_fr_htm ?hin_mng)
         (print_man_tran_row  ?p_id ?s_id ?id ?chnk_fr_htm ?man_mng)
         (print_suggestion_row  ?p_id ?s_id ?id ?chnk_fr_htm ?man_mng)
         (assert (id-len (+ ?id 1) (- ?len 1))) 
 )

 (defrule default_print_to_html
 (declare (salience 4898))
 (para_id-sent_id-no_of_words ?p_id ?s_id ?n_words)
 ?f<-(id-len ?id ?len)
 (hin_pos-hin_mng-eng_ids-eng_words ?id ?hin $?eng_ids ?id1 ?eng)
 (chunk-ids ?chunk_type ?chnk_fr_htm $?ids)
 (test (member$ ?id1 $?ids))
 =>
         (retract ?f)
         (print_anu_eng_row  ?p_id ?s_id ?id ?chnk_fr_htm ?eng)
         (print_anu_tran_row  ?p_id ?s_id ?id ?chnk_fr_htm ?hin)
         (print_man_tran_row  ?p_id ?s_id ?id ?chnk_fr_htm -)
         (print_suggestion_row  ?p_id ?s_id ?id ?chnk_fr_htm -)
         (assert (id-len (+ ?id 1) (- ?len 1)))
 )

;--------------------------------------------------------------------------------------------
;Printing newly added words ih hindi order [As newly added words doesn't have chunker information] this rule is written separetely
;Ex Do you think we should go to the party? ==> [kyA] Apa socawe hEM [ki] hameM/hamako pArtI ko jAnA cAhiye?
 (defrule new_words
 (declare (salience 4850))
 (para_id-sent_id-no_of_words ?p_id ?s_id ?n_words)
 ?f<-(id-len ?id ?len)
 (hin_pos-hin_mng-eng_ids-eng_words ?id ?hin $?grp ?eng)
 (test (!= ?len 0))
 =>
         (retract ?f)
         (print_anu_eng_row  ?p_id ?s_id ?id U ?eng)
         (print_anu_tran_row  ?p_id ?s_id ?id U ?hin)
         (print_man_tran_row  ?p_id ?s_id ?id U -)
         (print_suggestion_row  ?p_id ?s_id ?id U -)
         (assert (id-len (+ ?id 1) (- ?len 1)))
 )

;--------------------------------------------------------------------------------------------
 (defrule default_rule
 (declare (salience 4800))
 (para_id-sent_id-no_of_words ?p_id ?s_id ?n_words)
 ?f<-(id-len ?id ?len)
 (test (!= ?len 0)) 
 =>
         (retract ?f)
         (print_anu_eng_row  ?p_id ?s_id ?id U - )
         (print_anu_tran_row  ?p_id ?s_id ?id U - )
         (print_man_tran_row  ?p_id ?s_id ?id U - )
         (print_suggestion_row  ?p_id ?s_id ?id U -)
         (assert (id-len (+ ?id 1) (- ?len 1)))
 )

;--------------------------------------------------------------------------------------------
 ;This rule loops through the all the sentences 
 ;i.e Prints some information of the present sentence and later clears all the information [here facts] and moves to the next sentence
 (defrule sent_end
 (declare (salience 5000))
 (para_id-sent_id-no_of_words ?p_id ?s_id ?n_words)
 ?f<-(id-len ? 0)
 =>
 (retract ?f)
 ;(printout t "para-id " ?p_id " " ?s_id  crlf)
 (if (and (= ?p_id 1) (= ?s_id 1)) then (printout fp "<div class=\"float_clear\"/>" crlf))
 (printout fp "<div class=\"submit_button_block\"><input class=\"submit_button\" type=\"submit\" value=\"Submit\" /></div></form> " crlf)

 (reset)
 (bind ?path (str-cat ?p_id "." (+ ?s_id 1) "/" all_facts))
 (bind ?rt_value (load-facts ?path))
 (if (eq ?rt_value FALSE) then
        (bind ?path (str-cat  (+ ?p_id 1) ".1/" all_facts))
        (bind ?rt_value1 (load-facts ?path))
        (if (eq ?rt_value1 FALSE) then
           (printout fp "<div class=\"float_clear\"/>" crlf)
           (printout fp "<div class=\"bottom\"></div>" crlf)
           (printout fp "</body>" crlf)
           (printout fp "</html>" crlf)
                (exit)
        )
 )
 (load-facts ?path)
 )

;-------------------------------------------------------------------------------------------------
