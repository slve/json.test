# https://github.com/slve/json.test
# sanitize removes the give paths from responses and expected to ignore changes we don't care
# shellcheck disable=SC2037
sanitize(){
  IFS= read out
  while read -r jqcmd
  do
    out=$(echo $out | jq $jqcmd 2>/dev/null)
  done < ./sanitize
  echo $out
}

# ellipsis truncates long string and adds '...'
ellipsis(){
  awk -v len=120 '{
    if (length($0) > len) print substr($0, 1, len-3) "...";
    else print;
  }'
}

# log pipes the input to ./log file and adds an empty line after
log(){ tee -a log; echo >> ./log; }

# cleanup + init
rm ./queries.sh ./responses ./expected ./titles ./log 2>/dev/null
touch ./queries.sh ./responses ./expected ./titles && chmod +x ./queries.sh

# generate ./titles
for f in *.test; do
 grep '^\s*\(title\|name\)\s*:\?' $f >> ./titles;
done
sed -i 's/^\s*\(title\|name\)\s*:\?\s*//' ./titles

# generate ./queries.sh
for f in *.test; do
 grep '^\s*\(given\|when\)\s*:\?' $f >> ./queries.sh;
done
sed -i 's/^\s*\(given\|when\)\s*:\?\s*//' ./queries.sh

# generate ./expected
for f in *.test; do
 grep '^\s*\(expect\|then\)\s*:\?' $f >> ./expected;
done
sed -i 's/^\s*\(expect\|then\)\s*:\?\s*//' ./expected

# actual run

# run the queries and generate ./responses
rm ./responses ./log 2>/dev/null
while read -r cmd
do
  out=`eval $cmd`
  echo $out >> ./responses
done < ./queries.sh

# generate ./expected if there is no one yet
if [ ! -r ./expected ]; then
  echo "Could not find ./expected file, so just cloned ./responses to make one."
  cp ./responses ./expected
  echo "Now returning with failure as a reminder to add your ./expected file to your repository."
  exit 1
fi

# go through each response and compare with the expected
i=0
passed=0
failed=0
exitcode=0
while IFS="$(printf '\t')" read -r resp exp query title
do
  i=$[i + 1]
  respSan=$(echo $resp | sanitize)
  expSan=$(echo $exp | sanitize)
  d=$(diff <(echo "$respSan" ) <(echo "$expSan"))
  if [[ ! -z $d ]]; then
    exitcode=1
    failed=$[failed + 1]
    printf 'Diff at: "%s". query: %s\n' "$title" "$query" | log | ellipsis
    printf 'Response: %s\n' "$resp" | log >/dev/null
    printf 'Expected: %s\n' "$exp" | log >/dev/null
    diff -u <(echo $expSan | jq -S .) <(echo $respSan | jq -S .) | log
  else
    passed=$[passed + 1]
  fi
done <<< "$(paste ./responses ./expected ./queries.sh ./titles)"

# test report
echo "Passed: $passed  Failed: $failed"
if (($exitcode > 0)); then
  echo "Some test have failed. See more in ./log";
  echo "Hint: you can copy ./responses over ./expected to have a fresh snapshot.";
fi

exit $exitcode
