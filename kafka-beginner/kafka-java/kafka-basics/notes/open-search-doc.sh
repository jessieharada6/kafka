# http://localhost:5601/app/dev_tools#/console
# GET /wikimedia/_doc/5T3JoIIBw5s1buzmILdI
{
  "_index" : "wikimedia",
  "_type" : "_doc",
  "_id" : "5T3JoIIBw5s1buzmILdI",
  "_version" : 1,
  "_seq_no" : 725,
  "_primary_term" : 1,
  "found" : true,
  "_source" : {
    # how record looks like from consumer
    "$schema" : "/mediawiki/recentchange/1.0.0",
    "meta" : {
      "uri" : "https://www.wikidata.org/wiki/Wikidata:Database_reports/Constraint_violations/P1266",
      "request_id" : "4823a2eb-55aa-456f-bb51-c9ff0a2c6522",
      "id" : "9ae20556-a2e0-4669-9c00-75f58a950611",
      "dt" : "2022-08-15T09:15:08Z",
      "domain" : "www.wikidata.org",
      "stream" : "mediawiki.recentchange",
      "topic" : "eqiad.mediawiki.recentchange",
      "partition" : 0,
      "offset" : 4087229116
    },
    "id" : 1757483703,
    "type" : "edit",
    "namespace" : 4,
    "title" : "Wikidata:Database reports/Constraint violations/P1266",
    "comment" : "report update for [[Property:P1266]]",
    "timestamp" : 1660554908,
    "user" : "KrBot2",
    "bot" : true,
    "minor" : false,
    "patrolled" : true,
    "length" : {
      "old" : 82241,
      "new" : 82241
    },
    "revision" : {
      "old" : 1703694955,
      "new" : 1704509053
    },
    "server_url" : "https://www.wikidata.org",
    "server_name" : "www.wikidata.org",
    "server_script_path" : "/w",
    "wiki" : "wikidatawiki",
    "parsedcomment" : """report update for <a href="/wiki/Property:P1266" title="Property:P1266">Property:P1266</a>"""
  }
}
