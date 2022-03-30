if [ -z "$GITHUB_TOKEN" ]; then
  echo "Set the GITHUB_TOKEN environment variable."
  exit 1
fi

if [ ! -z "$SOURCE_BRANCH" ]; then
  SOURCE_BRANCH="$SOURCE_BRANCH"
elif [ ! -z "$GITHUB_REF_NAME" ]; then
  SOURCE_BRANCH="$GITHUB_REF_NAME"
else
  echo "Set the SOURCE_BRANCH environment variable or trigger from a branch."
  exit 1
fi

# Workaround for `hub` auth error https://github.com/github/hub/issues/2149#issuecomment-513214342
export GITHUB_USER="$GITHUB_ACTOR"

git config --global user.email "$GITHUB_ACTOR"
git config --global user.name "$GITHUB_ACTOR"
git config --global pull.ff only

git clone "https://$GITHUB_ACTOR:$GITHUB_TOKEN@github.com/$GITHUB_REPOSITORY" repo
git fetch
cd repo
git checkout $SOURCE_BRANCH
git pull
git push
git checkout $DESTINATION_BRANCH
git pull
git push
git merge $SOURCE_BRANCH
# git add -A
# git commit -m "update $DESTINATION_BRANCH"
git push --force