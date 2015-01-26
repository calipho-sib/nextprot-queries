## Example queries
Example queries used for the documentation

#### Naming convention
For queries to be published, use: 
> NXQ_*nnnnn*.rq 
> where *nnnnn* is a five digit number 

For queries used internally or which need further validation, use:
> NXQ_*nnnnn*.rq.unpub 

#### File content structure
The file contains meta-information fields followed by the SPARQL query itself.
The meta-inoformation fields are:
- #id: identifies the query (should correspond to file name without extension)
- #title: english free text translation of the SPARQL query 
- #comment: useful info about query (multiple lines prefixed with #comment are allowed)
- #tags: a list of comma separated categories for classifying & searching queries
  - add tag `snorql-only` for queries not returning protein entries
- #acs: a sample of uniprot style perotein accession codes returned by the query
- #count: the count of entries returned by the query (approximative)


Example:
```
#id:NXQ_00001
#title:Proteins phosphorylated and located in the cytoplasm
#comment:In this query we use the keyword "Phosphorylation" (KW-0597) and the UniProt subcellur location ontology term "Cytoplasm" (SL-0886).
#comment:Using the "childOf" allows to select for subcellular locations that are, in that ontology, children of cytoplasm like for example "Cell cortex".
#tags:subcellular location,cellular component,PTM,phosphorylation
#acs:A1A4S6,A1KZ92,A1L020
#count:3680
select distinct ?entry where {
  ?entry :isoform ?iso.
  ?iso :keyword / :term cv:KW-0597.
  ?iso :cellularComponent /:term /:childOf cv:SL-0086.
}
```



