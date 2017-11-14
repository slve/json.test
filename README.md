![GitHub code size in bytes](https://img.shields.io/badge/LOC-70-brightgreen.svg)
# json.test
## API integration test runner and reporter using .json files

### Intro
1. Edit `./queries.sh` add your [`curl`](https://en.wikipedia.org/wiki/CURL) commands.
Hint: You can copy them in your Network tab: right click, Copy > Copy as cURL. Works in modern browsers.
2. Run `./main.sh`.
3. Json.test will run each lines in your `./queries.sh`.
4. On the first run json.test will generate the `./expected` file based on your . files; `./expected` will be your snapshot but you can edit it; is just simply text.
5. Discover the [jq tutorial](https://stedolan.github.io/jq/tutorial/) and the local `./sanitize` file here in the repo, which serves not only as an example but json.test actively uses it.
6. Discover the source code [main.sh](https://github.com/slve/json.test/blob/master/main.sh).
7. Tip: Don't forget to check out [har.test](https://github.com/slve/har.test) a similar tool that may take some more work off of your shoulders.
8. Give it a star and fork it, create your private clone, add your `.gitignore` to your needs and link it into your [CI](https://en.wikipedia.org/wiki/Continuous_integration) flow.

### Output
* The output will go to stdout so you could pipe it into a file for example, but there is a more detailed `./log` file. Also, the exit code can be 0 if all test passed, or 1 if any of the tests have failed, so is compatible with the standard [CI](https://en.wikipedia.org/wiki/Continuous_integration) tools.

### Goal
* The original goal was an easy setup [integration test](https://en.wikipedia.org/wiki/Integration_testing) runner and reporter.

### Advantages
* Small set of dependencies: some common [GNU](https://www.gnu.org/) commands plus [jq](https://stedolan.github.io/jq/),
* ~70 lines of shell script - lightweight codebase,
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
