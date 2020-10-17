let parse_args () =
  Clap.description "A little CLI tool to get the bibtex entry for a given DOI or arXivID.";
  let id =
    Clap.mandatory_string
      ~last:true
      ~description:
        "A DOI or an arXiv ID. The tool tries to automatically infer what kind of ID you \
         are using. You can force the cli to lookup a DOI by using the form 'doi:ID' or \
         an arXiv ID by using the form 'arXiv:ID'."
      ~placeholder:"ID"
      ()
  in
  Clap.close ();
  id

let () =
  let open Doi2bib in
  let module Io = Doi2bib.IO(Cohttp_lwt_unix.Client) in
  let id = parse_args () |> parse_id in
  let open Lwt.Syntax in
  Lwt_main.run
    (let* bibtex = Io.get_bib_entry id in
     Lwt_io.printf "%s" bibtex)
