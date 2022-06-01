if [ "$(cat $1)" = "abc" ]; then
  echo "Passed"
  exit 0
else
  echo "Failed"
  exit 1
fi