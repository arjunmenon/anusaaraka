(load "path_for_html.clp")
(bind ?path1 ?*path*)
(bind ?*path* (str-cat ?*path* "/Anu_clp_files/create_xml_file.clp"))
(load ?*path*)
(bind ?mypath1 ?*mypath*)
(bind ?*mypath* (str-cat ?*mypath* "/tmp/" ?*filename* "_tmp/1.1/all_facts"))
(load-facts ?*mypath*)
(bind ?mypath1 (str-cat ?*filename* ".xml"))
(open ?mypath1 fp "a")
(run)
(close fp)
(exit)
