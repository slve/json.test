![GitHub code size in bytes](https://img.shields.io/badge/LOC-94-brightgreen.svg)
# json.test
## API integration test runner and reporter using .json files

### How it works
```
./main.sh
runs all queries            -> saves responses -> compares -> reports -> logs failures

./queries.sh                   ./responses        ./expected             ./log
curl -XPOST ...1 -d '{..1}'    {"a":1}            {"a":1}     Pass       Diff at line: 2. query: curl '...'
curl -XPOST ...2 -d '{..2}'    {"b":1}            {"b":2}     Fail       Response: { "userId": 1, ... }
                                                                         Expected: { "userId": 2, ... }

compare does sanitization both on ./responses and ./expected using ./sanitize
```

### Intro
1. Discover `./example.test` add your tests use any commands like [`curl`](https://en.wikipedia.org/wiki/CURL) or [`mongorestore`](https://docs.mongodb.com/manual/reference/program/mongorestore/).
   Hint: You can copy cURL commands in your Network tab: right click, Copy > Copy as cURL. Works in modern browsers.
2. Run `./main.sh`.
   Background: Json.test takes all the .test files in this folder and generates ./titles ./expected and ./queries.sh. These are just helper files, you can even add them to your .gitignore file.
   Json.test then runs ./queries.sh, sanitizes, compares and reports.
3. Check out the output and the ./log file.
4. Discover the [jq tutorial](https://stedolan.github.io/jq/tutorial/) and the local `./sanitize` file here in the repo, which serves not only as an example but json.test actively uses it.
5. Discover the source code [main.sh](https://github.com/slve/json.test/blob/master/main.sh).
6. Tip: Don't forget to check out [har.test](https://github.com/slve/har.test) a similar tool that may take some more work off of your shoulders.
7. Give it a star and fork it, create your private clone, add your `.gitignore` to your needs and link it into your [CI](https://en.wikipedia.org/wiki/Continuous_integration) flow.

### Output
* The output will go to stdout so you could pipe it into a file for example, but there is a more detailed `./log` file. Also, the exit code can be 0 if all test passed, or 1 if any of the tests have failed, so is compatible with the standard [CI](https://en.wikipedia.org/wiki/Continuous_integration) tools.

### Goal
* The original goal was an easy setup [integration test](https://en.wikipedia.org/wiki/Integration_testing) runner and reporter.

### Advantages
* Small set of dependencies: some common [GNU](https://www.gnu.org/) commands plus [jq](https://stedolan.github.io/jq/),
* 94 lines of shell script - lightweight codebase,
* and so its easy to fork and hack it to your own needs.

### Dependencies
* jq - [stedolan.github.io](https://stedolan.github.io/jq/)
* curl - you probably have one already
* diff - same here
* awk - again

### Limitations that might change in the future
* json.test manages only a single `./queries.sh`
* also, each test cases are processed syncronously
* there is no HTTP response code checking
* there is no option for any kind of timing, unless you for example add `sleep X &&` at the beginning of your command in `./queries.sh`, where X is in seconds.

### References and similar tools
* https://github.com/slve/har.test
* https://github.com/visionmedia/supertest
* https://en.wikipedia.org/wiki/CURL
