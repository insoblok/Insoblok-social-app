declare const AllNews: {
    readonly metadata: {
        readonly allOf: readonly [{
            readonly type: "object";
            readonly properties: {
                readonly apiKey: {
                    readonly type: "string";
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                };
                readonly q: {
                    readonly type: "string";
                    readonly default: "recall OR \"safety concern*\"";
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Search query, each article will be scored and ranked against it. Articles are searched on the title, description, and content fields.  <a href=\"/docs/search-concepts\">More ➜</a>";
                };
                readonly title: {
                    readonly type: "string";
                    readonly default: "tesla OR TSLA OR \"General Motors\" OR GM";
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Search article headlines/title field. Semantic similar to q parameter.";
                };
                readonly desc: {
                    readonly type: "string";
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Search query on the description field. Semantic similar to q parameter.";
                };
                readonly content: {
                    readonly type: "string";
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Search query on the article's body of content field. Semantic similar to q parameter.";
                };
                readonly url: {
                    readonly type: "string";
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Search query on the url field. Semantic similar to q parameter. E.g. could be used for querying certain website sections, e.g. source=cnn.com&url=travel.";
                };
                readonly articleId: {
                    readonly type: "string";
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Article ID will search for a news article by the ID of the article. If several parameters are passed, all matched articles will be returned.";
                };
                readonly clusterId: {
                    readonly type: "string";
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Search for related content using a cluster ID. Passing a cluster ID will filter results to only the content found within the cluster.";
                };
                readonly from: {
                    readonly type: "string";
                    readonly format: "date-time";
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "'from' filter, will search articles published after the specified date, the date could be passed as ISO or 'yyyy-mm-dd'. Add time in ISO format, ie. 2023-03-01T00:00:00";
                };
                readonly to: {
                    readonly type: "string";
                    readonly format: "date-time";
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "'to' filter, will search articles published before the specified date, the date could be passed as ISO or 'yyyy-mm-dd'. Add time in ISO format, ie. 2022-02-01T23:59:59";
                };
                readonly addDateFrom: {
                    readonly type: "string";
                    readonly format: "date-time";
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "'addDateFrom' filter, will search articles added after the specified date, the date could be passed as ISO or 'yyyy-mm-dd'. Add time in ISO format, ie. 2022-02-01T00:00:00";
                };
                readonly addDateTo: {
                    readonly type: "string";
                    readonly format: "date-time";
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "'addDateTo' filter, will search articles added before the specified date, the date could be passed as ISO or 'yyyy-mm-dd'. Add time in ISO format, ie. 2022-02-01T23:59:59";
                };
                readonly refreshDateFrom: {
                    readonly type: "string";
                    readonly format: "date-time";
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Will search articles that were refreshed after the specified date. The date could be passed as ISO or 'yyyy-mm-dd'.  Add time in ISO format, ie. 2022-02-01T00:00:00";
                };
                readonly refreshDateTo: {
                    readonly type: "string";
                    readonly format: "date-time";
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Will search articles that were refreshed before the specified date. The date could be passed as ISO or 'yyyy-mm-dd'. Add time in ISO format, ie. 2022-02-01T23:59:59";
                };
                readonly medium: {
                    readonly type: "string";
                    readonly enum: readonly ["Article", "Video"];
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Medium will filter out news articles medium, which could be 'Video' or 'Article'. If several parameters are passed, all matched articles will be returned.";
                };
                readonly source: {
                    readonly type: "string";
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Publisher's domain can include a subdomain. If multiple parameters are passed, they will be applied as OR operations. Wildcards (\\* and ?) are suported (e.g. \\*.cnn.com). <a href=\"/docs/sources-source-groups\">More ➜</a>";
                };
                readonly sourceGroup: {
                    readonly type: "string";
                    readonly enum: readonly ["top10", "top100", "top25crypto", "top25finance", "top50tech", "top100sports", "top100leftUS", "top100rightUS", "top100centerUS"];
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "One of the supported source groups. Find Source Groups in the guided part of our documentation... <a href=\"/docs/sources-source-groups\">More ➜</a>";
                };
                readonly excludeSource: {
                    readonly type: "string";
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "The domain of the website, which should be excluded from the search. Multiple parameters could be provided. Wildcards (\\* and ?) are suported (e.g. \\*.cnn.com).";
                };
                readonly paywall: {
                    readonly type: "boolean";
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Filter to show only results where the source has a paywall (true) or does not have a paywall (false).";
                };
                readonly byline: {
                    readonly type: "string";
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Author names to filter by. Article author bylines are used as a source field. If multiple parameters are passed, they will be applied as OR operations.";
                };
                readonly journalistId: {
                    readonly type: "string";
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Filter by journalist ID. Journalist IDs are unique journalist identifiers which can be found through the Journalist API, or in the matchedAuthors field.  <a href=\"/docs/journalist-data\">More ➜</a>";
                };
                readonly language: {
                    readonly type: "string";
                    readonly enum: readonly ["da", "de", "en", "es", "fi", "fr", "hu", "it", "nl", "no", "pl", "pt", "ru", "sv", "uk"];
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Language code to filter by language. If multiple parameters are passed, they will be applied as OR operations. <a href=\"/docs/countries-languages\">More ➜</a>";
                };
                readonly searchTranslation: {
                    readonly type: "boolean";
                    readonly default: false;
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Expand a query to search the translation, translatedTitle, and translatedDescription fields for non-English articles.";
                };
                readonly label: {
                    readonly type: "string";
                    readonly enum: readonly ["Opinion", "Non-news", "Paid News", "Fact Check", "Pop Culture", "Roundup", "Press Release", "Low Content"];
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Labels to filter by, could be 'Opinion', 'Paid-news', 'Non-news', etc. If multiple parameters are passed, they will be applied as OR operations.  <a href=\"/docs/article-types-labels#labels\">More ➜</a>";
                };
                readonly excludeLabel: {
                    readonly type: "string";
                    readonly enum: readonly ["Opinion", "Non-news", "Paid News", "Fact Check", "Pop Culture", "Roundup", "Press Release", "Low Content"];
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Exclude results that include specific labels (Opinion, Non-news, Paid News, etc.). You can filter multiple by repeating the parameter.";
                };
                readonly category: {
                    readonly type: "string";
                    readonly enum: readonly ["Politics", "Tech", "Sports", "Business", "Finance", "Entertainment", "Health", "Weather", "Lifestyle", "Auto", "Science", "Travel", "Environment", "World", "General", "none"];
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Filter by categories. Categories are general themes that the article is about. Examples of categories: Tech, Politics, etc. If multiple parameters are passed, they will be applied as OR operations. Use 'none' to search uncategorized articles. <a href=\"/docs/topics-categories#categories\">More ➜</a>";
                };
                readonly topic: {
                    readonly type: "string";
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Filter by topics. Each topic is some kind of entity that the article is about. Examples of topics: Markets, Joe Biden, Green Energy, Climate Change, Cryptocurrency, etc. If multiple parameters are passed, they will be applied as OR operations. <a href=\"/docs/topics-categories#topics\">More ➜</a>";
                };
                readonly excludeTopic: {
                    readonly type: "string";
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Filter by excluding topics. Each topic is some kind of entity that the article is about. Examples of topics: Markets, Joe Biden, Green Energy, Climate Change, Cryptocurrency, etc. If multiple parameters are passed, they will be applied as OR operations. <a href=\"/docs/topics-categories#topics\">More ➜</a>";
                };
                readonly linkTo: {
                    readonly type: "string";
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Returns only articles that point to specified links (as determined by the 'links' field in the article response).";
                };
                readonly showReprints: {
                    readonly type: "boolean";
                    readonly default: true;
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Whether to return reprints in the response or not. Reprints are usually wired articles from sources like AP or Reuters that are reprinted in multiple sources at the same time. By default, this parameter is 'true'.";
                };
                readonly reprintGroupId: {
                    readonly type: "string";
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Shows all articles belonging to the same reprint group. A reprint group includes one original article (the first one processed by the API) and all its known reprints.";
                };
                readonly city: {
                    readonly type: "string";
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Filters articles where a specified city plays a central role in the content, beyond mere mentions, to ensure the results are deeply relevant to the urban area in question. If multiple parameters are passed, they will be applied as OR operations.";
                };
                readonly area: {
                    readonly type: "string";
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Filters articles where a specified area, such as a neighborhood, borough, or district, plays a central role in the content, beyond mere mentions, to ensure the results are deeply relevant to the area in question. If multiple parameters are passed, they will be applied as OR operations.";
                };
                readonly state: {
                    readonly type: "string";
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Filters articles where a specified state plays a central role in the content, beyond mere mentions, to ensure the results are deeply relevant to the state in question. If multiple parameters are passed, they will be applied as OR operations.";
                };
                readonly locationsCountry: {
                    readonly type: "string";
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Filters articles where a specified country plays a central role in the content, beyond mere mentions, to ensure the results are deeply relevant to the country in question. If multiple parameters are passed, they will be applied as OR operations.";
                };
                readonly excludeLocationsCountry: {
                    readonly type: "string";
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Excludes articles where a specified country plays a central role in the content, ensuring results are not deeply relevant to the country in question. If multiple parameters are passed, they will be applied as AND operations, excluding articles relevant to any of the specified countries.";
                };
                readonly location: {
                    readonly type: "string";
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Return all articles that have the specified location. Location attributes are delimited by ':' between key and value, and '::' between attributes. Example: 'city:New York::state:NY'.";
                };
                readonly lat: {
                    readonly type: "number";
                    readonly format: "float";
                    readonly minimum: -3.402823669209385e+38;
                    readonly maximum: 3.402823669209385e+38;
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Latitude of the center point to search places";
                };
                readonly lon: {
                    readonly type: "number";
                    readonly format: "float";
                    readonly minimum: -3.402823669209385e+38;
                    readonly maximum: 3.402823669209385e+38;
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Longitude of the center point to search places";
                };
                readonly maxDistance: {
                    readonly type: "integer";
                    readonly format: "int32";
                    readonly minimum: -2147483648;
                    readonly maximum: 2147483647;
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Maximum distance (in km) from starting point to search articles by tagged places";
                };
                readonly sourceCity: {
                    readonly type: "string";
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Find articles published by sources that are located within a given city.";
                };
                readonly sourceCounty: {
                    readonly type: "string";
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Find articles published by sources that are located within a given county.";
                };
                readonly sourceCountry: {
                    readonly type: "string";
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Find articles published by sources that are located within a given country.  Must be 2 character country code  (i.e. us, gb, etc).";
                };
                readonly country: {
                    readonly type: "string";
                    readonly enum: readonly ["us", "gb", "de", "it", "fr", "nl", "se", "dk", "fi", "hu", "no", "pl", "pt", "ru", "ua", "ch", "br", "nz", "mx", "au"];
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Country code to filter by country. If multiple parameters are passed, they will be applied as OR operations.";
                };
                readonly sourceState: {
                    readonly type: "string";
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Find articles published by sources that are located within a given state.";
                };
                readonly sourceLon: {
                    readonly type: "number";
                    readonly format: "float";
                    readonly minimum: -3.402823669209385e+38;
                    readonly maximum: 3.402823669209385e+38;
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Latitude of the center point to search articles created by local publications.";
                };
                readonly sourceLat: {
                    readonly type: "number";
                    readonly format: "float";
                    readonly minimum: -3.402823669209385e+38;
                    readonly maximum: 3.402823669209385e+38;
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Latitude of the center point to search articles created by local publications.";
                };
                readonly sourceMaxDistance: {
                    readonly type: "integer";
                    readonly format: "int32";
                    readonly minimum: -2147483648;
                    readonly maximum: 2147483647;
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Maximum distance from starting point to search articles created by local publications.";
                };
                readonly personWikidataId: {
                    readonly type: "array";
                    readonly items: {
                        readonly type: "string";
                    };
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "List of person Wikidata IDs for filtering.";
                };
                readonly personName: {
                    readonly type: "array";
                    readonly items: {
                        readonly type: "string";
                    };
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "List of person names for exact matches. Boolean and complex logic is not supported on this paramter.";
                };
                readonly companyId: {
                    readonly type: "array";
                    readonly items: {
                        readonly type: "string";
                    };
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "List of company IDs to filter by.";
                };
                readonly companyName: {
                    readonly type: "string";
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Search by company name.";
                };
                readonly companyDomain: {
                    readonly type: "array";
                    readonly items: {
                        readonly type: "string";
                    };
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Search by company domains for filtering. E.g. companyDomain=apple.com.";
                };
                readonly companySymbol: {
                    readonly type: "array";
                    readonly items: {
                        readonly type: "string";
                    };
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Search by company symbols.";
                };
                readonly page: {
                    readonly type: "integer";
                    readonly format: "int32";
                    readonly minimum: -2147483648;
                    readonly maximum: 2147483647;
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Zero-based page number. From 0 to 10000. See the Pagination section for limitations.";
                };
                readonly size: {
                    readonly type: "integer";
                    readonly format: "int32";
                    readonly minimum: -2147483648;
                    readonly maximum: 2147483647;
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Number of articles returned per page, from 0 to 100.";
                };
                readonly sortBy: {
                    readonly type: "string";
                    readonly enum: readonly ["date", "relevance", "addDate", "pubDate", "refreshDate"];
                    readonly default: "relevance";
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "'relevance' to sort by relevance to the query, 'date' to sort by the publication date (desc), 'pubDate' is a synonym to 'date', 'addDate' to sort by 'addDate' field (desc), 'refreshDate' to sort by 'refreshDate' field (desc).";
                };
                readonly showNumResults: {
                    readonly type: "boolean";
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Whether to show the total number of all matched articles. Default value is false which makes queries a bit more efficient but also counts up to 10000 articles.";
                };
                readonly positiveSentimentFrom: {
                    readonly type: "number";
                    readonly format: "float";
                    readonly minimum: -3.402823669209385e+38;
                    readonly maximum: 3.402823669209385e+38;
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Filters results with a sentiment score greater than or equal to the specified value, indicating positive sentiment. See the Article Data section in Docs for an explanation of scores.";
                };
                readonly positiveSentimentTo: {
                    readonly type: "number";
                    readonly format: "float";
                    readonly minimum: -3.402823669209385e+38;
                    readonly maximum: 3.402823669209385e+38;
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Filters results with a sentiment score less than or equal to the specified value, indicating positive sentiment. See the Article Data section in Docs for an explanation of scores.";
                };
                readonly neutralSentimentFrom: {
                    readonly type: "number";
                    readonly format: "float";
                    readonly minimum: -3.402823669209385e+38;
                    readonly maximum: 3.402823669209385e+38;
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Filters results with a sentiment score greater than or equal to the specified value, indicating neutral sentiment. Explanation of sentimental values can be found in Docs under the Article Data section.";
                };
                readonly neutralSentimentTo: {
                    readonly type: "number";
                    readonly format: "float";
                    readonly minimum: -3.402823669209385e+38;
                    readonly maximum: 3.402823669209385e+38;
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Filters results with a sentiment score less than or equal to the specified value, indicating neutral sentiment. See the Article Data section in Docs for an explanation of scores.";
                };
                readonly negativeSentimentFrom: {
                    readonly type: "number";
                    readonly format: "float";
                    readonly minimum: -3.402823669209385e+38;
                    readonly maximum: 3.402823669209385e+38;
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Filters results with a sentiment score greater than or equal to the specified value, indicating negative sentiment. See the Article Data section in Docs for an explanation of scores.";
                };
                readonly negativeSentimentTo: {
                    readonly type: "number";
                    readonly format: "float";
                    readonly minimum: -3.402823669209385e+38;
                    readonly maximum: 3.402823669209385e+38;
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Filters results with a sentiment score less than or equal to the specified value, indicating negative sentiment. See the Article Data section in Docs for an explanation of scores.";
                };
                readonly taxonomy: {
                    readonly type: "string";
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Filters by Google Content Categories. This field will accept 1 or more categories, must pass the full name of the category. Example: taxonomy=/Finance/Banking/Other, /Finance/Investing/Funds";
                };
                readonly prefixTaxonomy: {
                    readonly type: "string";
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Filters by Google Content Categories. This field will filter by the category prefix only. Example: prefixTaxonomy=/Finance";
                };
            };
            readonly required: readonly ["apiKey"];
        }];
    };
    readonly response: {
        readonly "200": {
            readonly type: "object";
            readonly properties: {
                readonly status: {
                    readonly type: "integer";
                    readonly default: 0;
                    readonly examples: readonly [200];
                };
                readonly numResults: {
                    readonly type: "integer";
                    readonly default: 0;
                    readonly examples: readonly [1];
                };
                readonly articles: {
                    readonly type: "array";
                    readonly items: {
                        readonly type: "object";
                        readonly properties: {
                            readonly url: {
                                readonly type: "string";
                                readonly examples: readonly ["https://decrypt.co/301053/nft-market-hits-three-year-low-in-trading-and-sales-report"];
                            };
                            readonly authorsByline: {
                                readonly type: "string";
                                readonly examples: readonly ["Vismaya V"];
                            };
                            readonly articleId: {
                                readonly type: "string";
                                readonly examples: readonly ["680d7893185c4357a9047332cf38206c"];
                            };
                            readonly clusterId: {
                                readonly type: "string";
                                readonly examples: readonly ["37426b0543cb45e3a547695fd63e9919"];
                            };
                            readonly source: {
                                readonly type: "object";
                                readonly properties: {
                                    readonly domain: {
                                        readonly type: "string";
                                        readonly examples: readonly ["decrypt.co"];
                                    };
                                    readonly paywall: {
                                        readonly type: "boolean";
                                        readonly default: true;
                                        readonly examples: readonly [false];
                                    };
                                    readonly location: {
                                        readonly type: "object";
                                        readonly properties: {
                                            readonly country: {
                                                readonly type: "string";
                                                readonly examples: readonly ["us"];
                                            };
                                            readonly state: {
                                                readonly type: "string";
                                                readonly examples: readonly ["NY"];
                                            };
                                            readonly city: {
                                                readonly type: "string";
                                                readonly examples: readonly ["New York"];
                                            };
                                            readonly coordinates: {
                                                readonly type: "object";
                                                readonly properties: {
                                                    readonly lat: {
                                                        readonly type: "number";
                                                        readonly default: 0;
                                                        readonly examples: readonly [40.7127281];
                                                    };
                                                    readonly lon: {
                                                        readonly type: "number";
                                                        readonly default: 0;
                                                        readonly examples: readonly [-74.0060152];
                                                    };
                                                };
                                            };
                                        };
                                    };
                                };
                            };
                            readonly imageUrl: {
                                readonly type: "string";
                                readonly examples: readonly ["https://cdn.decrypt.co/resize/1024/height/512/wp-content/uploads/2021/07/The-Bored-Ape-Yacht-Club-gID_7.jpeg"];
                            };
                            readonly country: {
                                readonly type: "string";
                                readonly examples: readonly ["us"];
                            };
                            readonly language: {
                                readonly type: "string";
                                readonly examples: readonly ["en"];
                            };
                            readonly pubDate: {
                                readonly type: "string";
                                readonly examples: readonly ["2025-01-15T09:20:34+00:00"];
                            };
                            readonly addDate: {
                                readonly type: "string";
                                readonly examples: readonly ["2025-01-15T09:27:57.156032+00:00"];
                            };
                            readonly refreshDate: {
                                readonly type: "string";
                                readonly examples: readonly ["2025-01-15T09:27:57.156034+00:00"];
                            };
                            readonly score: {
                                readonly type: "number";
                                readonly default: 0;
                                readonly examples: readonly [52.79721];
                            };
                            readonly title: {
                                readonly type: "string";
                                readonly examples: readonly ["NFT Market Hits Three-Year Low in Trading and Sales: Report"];
                            };
                            readonly description: {
                                readonly type: "string";
                                readonly examples: readonly ["Annual NFT trading volumes fell by 19%, while sales counts dipped by 18% compared to 2023, according to DappRadar."];
                            };
                            readonly content: {
                                readonly type: "string";
                                readonly examples: readonly ["The NFT market suffered a dismal 2024, with trading volumes and sales counts dropping to their weakest levels since 2020.\n\nAnnual trading volumes fell by 19%, while sales counts dipped by 18% compared to 2023, according to a report by blockchain analytics platform.\n\nDespite a surge in crypto market activity, driven by Bitcoin’s all-time highs and booming DeFi growth, NFTs appeared to struggle under the weight of their own inflated valuations.\n\nEarly in the year, NFT trading volumes reached $5.3 billion in Q1, a modest 4% increase compared to the same period in 2023.\n\nHowever, this momentum proved fleeting, as volumes plummeted to $1.5 billion in Q3 before recovering slightly to $2.6 billion in Q4.\n\nEven with these fluctuations, annual sales counts fell sharply, pointing to a broader trend: while individual NFTs became more expensive in line with rising crypto token prices, overall market engagement dwindled.\n\nYuga Labs’ flagship collections Bored Ape Yacht Club (BAYC) and Mutant Ape Yacht Club (MAYC) hit historic lows, with floor prices dropping to 15 ETH and 2.4 ETH, respectively.\n\nEven Otherdeeds for Yuga Labs' Otherside metaverse plummeted to 0.23 ETH, a far cry from their initial minting price, exposing cracks in Yuga’s high-priced, membership-driven model.\n\nThis coincided with DappRadar’s observation that “Perhaps 2024 helped us realize that NFTs don’t need to be expensive to prove their importance in the broader Web3 ecosystem,” a critique of the market’s reliance on exclusivity and inflated pricing.\n\nAmid this downturn, the NFT market witnessed a paradox in November when CryptoPunk #8348, a rare seven-trait collectible from the NFT collection, was collateralized for a $2.75 million loan via the NFT lending platform GONDI.\n\nTouted as a milestone for NFTs as financial assets, this event showed speculative excess when juxtaposed with DappRadar’s insights about affordability and utility.\n\nWhile high-profile transactions like this aim to affirm NFTs’ value, they also highlight a market still driven by exclusivity and inflated pricing, even as wider participation wanes.\n\nEven within the struggling sector, blue-chip collections like CryptoPunks defied trends, nearly doubling in USD value in 2024 with notable sales driving brief recovery periods.\n\nNFT platforms like Blur dominated marketplace activity, leveraging zero-fee trading and aggressive airdrop campaigns to capture the largest share of trading volumes.\n\nIn contrast, rival marketplace OpenSea struggled with regulatory headwinds and declining market sentiment, forcing significant layoffs by year-end.\n\nBy Q4, Blur and OpenSea were neck-and-neck in market share, but Blur’s ability to generate high activity from a smaller, more active user base gave it the edge, as per the report.\n\nWhile trading volumes in late 2024 hinted at a potential recovery—November sales hit $562 million, the highest since May—the overall trajectory suggests that affordability, accessibility, and utility will be critical for sustained growth in 2025."];
                            };
                            readonly medium: {
                                readonly type: "string";
                                readonly examples: readonly ["Article"];
                            };
                            readonly links: {
                                readonly type: "array";
                                readonly items: {
                                    readonly type: "string";
                                    readonly examples: readonly ["https://dappradar.com/blog/dapp-industry-report-2024-overview"];
                                };
                            };
                            readonly labels: {
                                readonly type: "array";
                                readonly items: {
                                    readonly type: "object";
                                    readonly properties: {
                                        readonly name: {
                                            readonly type: "string";
                                            readonly examples: readonly ["Roundup"];
                                        };
                                    };
                                };
                            };
                            readonly matchedAuthors: {
                                readonly type: "array";
                                readonly items: {
                                    readonly type: "object";
                                    readonly properties: {
                                        readonly id: {};
                                        readonly name: {
                                            readonly type: "string";
                                            readonly examples: readonly ["Vismaya V"];
                                        };
                                    };
                                };
                            };
                            readonly claim: {
                                readonly type: "string";
                                readonly examples: readonly [""];
                            };
                            readonly verdict: {
                                readonly type: "string";
                                readonly examples: readonly [""];
                            };
                            readonly keywords: {
                                readonly type: "array";
                                readonly items: {
                                    readonly type: "object";
                                    readonly properties: {
                                        readonly name: {
                                            readonly type: "string";
                                            readonly examples: readonly ["NFT trading volumes"];
                                        };
                                        readonly weight: {
                                            readonly type: "number";
                                            readonly default: 0;
                                            readonly examples: readonly [0.095650345];
                                        };
                                    };
                                };
                            };
                            readonly topics: {
                                readonly type: "array";
                                readonly items: {};
                            };
                            readonly categories: {
                                readonly type: "array";
                                readonly items: {};
                            };
                            readonly taxonomies: {
                                readonly type: "array";
                                readonly items: {
                                    readonly type: "object";
                                    readonly properties: {
                                        readonly name: {
                                            readonly type: "string";
                                            readonly examples: readonly ["/Finance/Investing/Currencies & Foreign Exchange"];
                                        };
                                    };
                                };
                            };
                            readonly entities: {
                                readonly type: "array";
                                readonly items: {
                                    readonly type: "object";
                                    readonly properties: {
                                        readonly data: {
                                            readonly type: "string";
                                            readonly examples: readonly ["Yuga Labs’"];
                                        };
                                        readonly type: {
                                            readonly type: "string";
                                            readonly examples: readonly ["ORG"];
                                        };
                                        readonly mentions: {
                                            readonly type: "integer";
                                            readonly default: 0;
                                            readonly examples: readonly [3];
                                        };
                                    };
                                };
                            };
                            readonly companies: {
                                readonly type: "array";
                                readonly items: {
                                    readonly type: "object";
                                    readonly properties: {
                                        readonly id: {
                                            readonly type: "string";
                                            readonly examples: readonly ["f0886b1323a142df88f521ba9a0bbedf"];
                                        };
                                        readonly name: {
                                            readonly type: "string";
                                            readonly examples: readonly ["OpenSea Ventures"];
                                        };
                                        readonly domains: {
                                            readonly type: "array";
                                            readonly items: {
                                                readonly type: "string";
                                                readonly examples: readonly ["opensea.io"];
                                            };
                                        };
                                        readonly symbols: {
                                            readonly type: "array";
                                            readonly items: {};
                                        };
                                    };
                                };
                            };
                            readonly sentiment: {
                                readonly type: "object";
                                readonly properties: {
                                    readonly positive: {
                                        readonly type: "number";
                                        readonly default: 0;
                                        readonly examples: readonly [0.033333376];
                                    };
                                    readonly negative: {
                                        readonly type: "number";
                                        readonly default: 0;
                                        readonly examples: readonly [0.89130986];
                                    };
                                    readonly neutral: {
                                        readonly type: "number";
                                        readonly default: 0;
                                        readonly examples: readonly [0.07535672];
                                    };
                                };
                            };
                            readonly summary: {
                                readonly type: "string";
                                readonly examples: readonly ["The National Finance Finance (NFT) market experienced a three-year low in 2024, with annual trading volumes and sales counts dropping to their lowest levels since 2020. The report by blockchain analytics platform DappRadar suggests that despite a surge in crypto market activity driven by Bitcoin's all-time highs and DeFi growth, NFTs struggled under the weight of their inflated valuations. Despite early Q1 trading volumes reaching $5.3 billion, a 4% increase compared to the same period in 2023, volumes dropped to $1.5 billion in Q3 before recovering to $2.6 billion by Q4. Despite these fluctuations, overall market engagement decreased. Despite this downturn, high-profile transactions like CryptoPunk #8348, a rare seven-trait collectible from the NFT collection, were seen as a milestone for NFT's value and highlighted a market still driven by exclusivity and inflated pricing."];
                            };
                            readonly translation: {
                                readonly type: "string";
                                readonly examples: readonly [""];
                            };
                            readonly translatedTitle: {
                                readonly type: "string";
                                readonly examples: readonly [""];
                            };
                            readonly translatedDescription: {
                                readonly type: "string";
                                readonly examples: readonly [""];
                            };
                            readonly translatedSummary: {
                                readonly type: "string";
                                readonly examples: readonly [""];
                            };
                            readonly locations: {
                                readonly type: "array";
                                readonly items: {};
                            };
                            readonly reprint: {
                                readonly type: "boolean";
                                readonly default: true;
                                readonly examples: readonly [false];
                            };
                            readonly reprintGroupId: {
                                readonly type: "string";
                                readonly examples: readonly ["3d67e5bf389b40b3895ae0708f4dd208"];
                            };
                            readonly places: {
                                readonly type: "array";
                                readonly items: {};
                            };
                            readonly people: {
                                readonly type: "array";
                                readonly items: {};
                            };
                        };
                    };
                };
            };
            readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
        };
        readonly "400": {
            readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
        };
        readonly "401": {
            readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
        };
        readonly "403": {
            readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
        };
        readonly "404": {
            readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
        };
        readonly "500": {
            readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
        };
    };
};
declare const Stories1: {
    readonly metadata: {
        readonly allOf: readonly [{
            readonly type: "object";
            readonly properties: {
                readonly apiKey: {
                    readonly type: "string";
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                };
                readonly q: {
                    readonly type: "string";
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Search story by name, summary and key points. Preference is given to the name field. Supports complex query syntax, same way as **q** parameter from **/all** endpoint.";
                };
                readonly name: {
                    readonly type: "string";
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Search story by name. Supports complex query syntax, same way as **q** parameter from **/all** endpoint.";
                };
                readonly topic: {
                    readonly type: "array";
                    readonly items: {
                        readonly type: "string";
                    };
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Filter by topics. Each topic is some kind of entity that the article is about. Examples of topics: Markets, Joe Biden, Green Energy, Climate Change, Cryptocurrency, etc. If multiple parameters are passed, they will be applied as OR operations. <a href=\"/docs/topics-categories#topics\">More ➜</a>";
                };
                readonly category: {
                    readonly type: "string";
                    readonly enum: readonly ["Politics", "Tech", "Sports", "Business", "Finance", "Entertainment", "Health", "Weather", "Lifestyle", "Auto", "Science", "Travel", "Environment", "World", "General", "none"];
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Filter by categories. Categories are general themes that the article is about. Examples of categories: Tech, Politics, etc. If multiple parameters are passed, they will be applied as OR operations. Use 'none' to search uncategorized articles. <a href=\"/docs/topics-categories#categories\">More ➜</a>";
                };
                readonly clusterId: {
                    readonly type: "array";
                    readonly items: {
                        readonly type: "string";
                    };
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Filter to specific story. Passing a cluster ID will filter results to only the content found within the cluster. Multiple params could be passed.";
                };
                readonly source: {
                    readonly type: "array";
                    readonly items: {
                        readonly type: "string";
                    };
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Filter stories by sources that wrote articles belonging to this story. At least 1 article is required for story to match. Multiple parameters could be passed.";
                };
                readonly sourceGroup: {
                    readonly type: "array";
                    readonly items: {
                        readonly type: "string";
                    };
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Filter stories by sources that wrote articles belonging to this story. Source groups are expanded into a list of sources. At least 1 article by the source is required for story to match. Multiple params could be passed.";
                };
                readonly personWikidataId: {
                    readonly type: "array";
                    readonly items: {
                        readonly type: "string";
                    };
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "List of person Wikidata IDs for filtering. Filter is applied on topPeople field.";
                };
                readonly personName: {
                    readonly type: "array";
                    readonly items: {
                        readonly type: "string";
                    };
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "List of people names. Filtering is applied on topPeople field.";
                };
                readonly companyId: {
                    readonly type: "array";
                    readonly items: {
                        readonly type: "string";
                    };
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "List of company IDs for filtering. Filtering is applied to topCompanies field.";
                };
                readonly companyName: {
                    readonly type: "array";
                    readonly items: {
                        readonly type: "string";
                    };
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "List of company names for filtering. Filtering is applied on topCompanies field.";
                };
                readonly companyDomain: {
                    readonly type: "array";
                    readonly items: {
                        readonly type: "string";
                    };
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "List of company domains for filtering. Filtering is applied on topCompanies field.";
                };
                readonly companySymbol: {
                    readonly type: "string";
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "List of company tickers for filtering. Filtering is applied on topCompanies field.";
                };
                readonly nameExists: {
                    readonly type: "boolean";
                    readonly default: true;
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Returns stories with name assigned. Defaults to true.";
                };
                readonly from: {
                    readonly type: "string";
                    readonly format: "date-time";
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "'from' filter, will search stories created after the specified date, the date could be passed as ISO or 'yyyy-mm-dd'. Add time in ISO format, ie. 2023-03-01T00:00:00";
                };
                readonly to: {
                    readonly type: "string";
                    readonly format: "date-time";
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "'to' filter, will search stories created before the specified date, the date could be passed as ISO or 'yyyy-mm-dd'. Add time in ISO format, ie. 2023-03-01T23:59:59";
                };
                readonly initializedFrom: {
                    readonly type: "string";
                    readonly format: "date";
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "'initializedFrom' filter, will search stories that became available after provided date";
                };
                readonly initializedTo: {
                    readonly type: "string";
                    readonly format: "date";
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "'initializedTo' filter, will search stories that became available before provided date";
                };
                readonly updatedFrom: {
                    readonly type: "string";
                    readonly format: "date";
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Will return stories with 'updatedAt' >= 'updatedFrom'.";
                };
                readonly updatedTo: {
                    readonly type: "string";
                    readonly format: "date";
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Will return stories with 'updatedAt' <= 'updatedTo'.";
                };
                readonly minClusterSize: {
                    readonly type: "integer";
                    readonly format: "int32";
                    readonly default: 5;
                    readonly minimum: -2147483648;
                    readonly maximum: 2147483647;
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Filter by minimum cluster size. Minimum cluster size filter applies to number of **unique** articles.";
                };
                readonly maxClusterSize: {
                    readonly type: "integer";
                    readonly format: "int32";
                    readonly minimum: -2147483648;
                    readonly maximum: 2147483647;
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Filter by maximum cluster size. Maximum cluster size filter applies to number of **unique** articles in the cluster.";
                };
                readonly state: {
                    readonly type: "array";
                    readonly items: {
                        readonly type: "string";
                    };
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Filter local news by state. Applies only to local news, when this param is passed non-local news will not be returned. If multiple parameters are passed, they will be applied as OR operations.";
                };
                readonly city: {
                    readonly type: "array";
                    readonly items: {
                        readonly type: "string";
                    };
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Filter local news by city. Applies only to local news, when this param is passed non-local news will not be returned. If multiple parameters are passed, they will be applied as OR operations. <a href=\"/docs/local-news\">More ➜</a>";
                };
                readonly area: {
                    readonly type: "array";
                    readonly items: {
                        readonly type: "string";
                    };
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Filter local news by area. Applies only to local news, when this param is passed non-local news will not be returned. If multiple parameters are passed, they will be applied as OR operations.";
                };
                readonly page: {
                    readonly type: "integer";
                    readonly format: "int32";
                    readonly default: 0;
                    readonly minimum: -2147483648;
                    readonly maximum: 2147483647;
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Zero-based page number. From 0 to 10000. See the Pagination section for limitations.";
                };
                readonly size: {
                    readonly type: "integer";
                    readonly format: "int32";
                    readonly default: 10;
                    readonly minimum: -2147483648;
                    readonly maximum: 2147483647;
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Number of stories results per page, from 0 to 100.";
                };
                readonly sortBy: {
                    readonly type: "string";
                    readonly enum: readonly ["createdAt", "updatedAt", "count"];
                    readonly default: "createdAt";
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Sort stories by count, creation date, last updated date. By default is sorted by created at.";
                };
                readonly showNumResults: {
                    readonly type: "boolean";
                    readonly default: false;
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Show total number of results. By default set to false, will cap result count at 10000.";
                };
                readonly showDuplicates: {
                    readonly type: "boolean";
                    readonly default: false;
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Stories are deduplicated by default. If a story is deduplicated, all future articles are merged into the original story. *duplicateOf* field contains the original cluster Id. When *showDuplicates=true*, all stories are shown.";
                };
                readonly positiveSentimentFrom: {
                    readonly type: "number";
                    readonly format: "float";
                    readonly minimum: -3.402823669209385e+38;
                    readonly maximum: 3.402823669209385e+38;
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Filters results with a sentiment score greater than or equal to the specified value, indicating positive sentiment. See the Article Data section in Docs for an explanation of scores.";
                };
                readonly positiveSentimentTo: {
                    readonly type: "number";
                    readonly format: "float";
                    readonly minimum: -3.402823669209385e+38;
                    readonly maximum: 3.402823669209385e+38;
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Filters results with a sentiment score less than or equal to the specified value, indicating positive sentiment. See the Article Data section in Docs for an explanation of scores.";
                };
                readonly neutralSentimentFrom: {
                    readonly type: "number";
                    readonly format: "float";
                    readonly minimum: -3.402823669209385e+38;
                    readonly maximum: 3.402823669209385e+38;
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Filters results with a sentiment score greater than or equal to the specified value, indicating neutral sentiment. Explanation of sentimental values can be found in Docs under the Article Data section.";
                };
                readonly neutralSentimentTo: {
                    readonly type: "number";
                    readonly format: "float";
                    readonly minimum: -3.402823669209385e+38;
                    readonly maximum: 3.402823669209385e+38;
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Filters results with a sentiment score less than or equal to the specified value, indicating neutral sentiment. See the Article Data section in Docs for an explanation of scores.";
                };
                readonly negativeSentimentFrom: {
                    readonly type: "number";
                    readonly format: "float";
                    readonly minimum: -3.402823669209385e+38;
                    readonly maximum: 3.402823669209385e+38;
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Filters results with a sentiment score greater than or equal to the specified value, indicating negative sentiment. See the Article Data section in Docs for an explanation of scores.";
                };
                readonly negativeSentimentTo: {
                    readonly type: "number";
                    readonly format: "float";
                    readonly minimum: -3.402823669209385e+38;
                    readonly maximum: 3.402823669209385e+38;
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Filters results with a sentiment score less than or equal to the specified value, indicating negative sentiment. See the Article Data section in Docs for an explanation of scores.";
                };
                readonly country: {
                    readonly type: "string";
                    readonly enum: readonly ["us", "gb", "de", "it", "fr", "nl", "se", "dk", "fi", "hu", "no", "pl", "pt", "ru", "ua", "ch", "br", "nz", "mx", "au"];
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Country code to filter by country. If multiple parameters are passed, they will be applied as OR operations.";
                };
                readonly taxonomy: {
                    readonly type: "string";
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Filters by Google Content Categories. This field will accept 1 or more categories, must pass the full name of the category. Example: taxonomy=/Finance/Banking/Other, /Finance/Investing/Funds";
                };
                readonly topTaxonomies: {
                    readonly type: "string";
                    readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
                    readonly description: "Filters by Google Content Categories. Highlights the top 3 categories in a cluster, ordered by count.";
                };
            };
            readonly required: readonly ["apiKey"];
        }];
    };
    readonly response: {
        readonly "200": {
            readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
        };
        readonly "400": {
            readonly type: "object";
            readonly properties: {
                readonly status: {
                    readonly type: "integer";
                    readonly default: 0;
                    readonly examples: readonly [400];
                };
                readonly message: {
                    readonly type: "string";
                    readonly examples: readonly ["Errors during parameter validation: \nError on parameter 'updatedFrom', invalid value 'test': Failed to convert property value of type 'java.lang.String' to required type 'java.time.OffsetDateTime' for property 'updatedFrom'; nested exception is org.springframework.core.convert.ConversionFailedException: Failed to convert from type [java.lang.String] to type [@com.gawq.api.formatting.DateTimeRequestParam java.time.OffsetDateTime] for value [test]; nested exception is java.lang.IllegalArgumentException: Parse attempt failed for value [test]"];
                };
                readonly timestamp: {
                    readonly type: "integer";
                    readonly default: 0;
                    readonly examples: readonly [1730827027255];
                };
            };
            readonly $schema: "https://json-schema.org/draft/2020-12/schema#";
        };
    };
};
export { AllNews, Stories1 };
