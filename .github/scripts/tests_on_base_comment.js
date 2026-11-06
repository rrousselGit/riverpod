// Posts the reports of scripts/tests_on_base.sh on a pull request: one
// comment listing the new tests that pass without the lib/ changes, and a
// review comment on each of those tests. The comments of earlier runs are
// updated, or deleted once their tests are no longer reported.
//
// Called from actions/github-script, with `pull` the pull request
// ({ number, head_sha }) and `dir` the folder holding the reports.

const fs = require('fs');
const path = require('path');

const bot = 'github-actions[bot]';
const marker = '<!-- tests-on-base -->';
// Review comments start with the test they are about, so that later runs
// find them.
const testMarker = test =>
  `<!-- tests-on-base ${encodeURIComponent(test.path)} ${encodeURIComponent(test.name)} -->`;

module.exports = async ({ github, context, core, pull, dir }) => {
  const repo = context.repo;
  let body = fs.readFileSync(path.join(dir, 'tests_on_base.md'), 'utf8').trim();
  // GitHub rejects comments over 65536 characters.
  if (body.length > 60000) body = `${body.slice(0, 60000)}\n\n…(truncated)`;
  if (body && !body.startsWith(marker)) body = `${marker}\n${body}`;
  const tests = JSON.parse(fs.readFileSync(path.join(dir, 'tests_on_base.json'), 'utf8'));

  const comments = await github.paginate(github.rest.issues.listComments, {
    ...repo,
    issue_number: pull.number,
  });
  const existing = comments.find(c => c.user.login === bot && c.body.startsWith(marker));
  // An empty report means no new test passes without the lib/ changes
  // anymore, so an earlier warning is outdated.
  if (!body) {
    if (existing) await github.rest.issues.deleteComment({ ...repo, comment_id: existing.id });
  } else if (existing) {
    await github.rest.issues.updateComment({ ...repo, comment_id: existing.id, body });
  } else {
    await github.rest.issues.createComment({ ...repo, issue_number: pull.number, body });
  }

  const reviewComments = await github.paginate(github.rest.pulls.listReviewComments, {
    ...repo,
    pull_number: pull.number,
  });
  const previous = new Map(
    reviewComments
      .filter(c => c.user.login === bot && c.body.startsWith('<!-- tests-on-base '))
      .map(c => [c.body.split('\n')[0], c]),
  );
  for (const test of tests) {
    // Tests declared in another file are only listed in the main comment.
    if (test.line == null) continue;
    const key = testMarker(test);
    if (previous.delete(key)) continue;
    try {
      await github.rest.pulls.createReviewComment({
        ...repo,
        pull_number: pull.number,
        commit_id: pull.head_sha,
        path: test.path,
        line: test.line,
        side: 'RIGHT',
        body: `${key}\n:warning: This test passes without the \`lib/\` changes of this PR, so it may not test them.`,
      });
    } catch (error) {
      // GitHub only accepts review comments on lines of the diff. The test
      // is still listed in the main comment.
      if (error.status !== 422) throw error;
      core.warning(`Could not comment on ${test.path}:${test.line}: ${error.message}`);
    }
  }
  // The tests left are no longer reported.
  for (const c of previous.values()) {
    await github.rest.pulls.deleteReviewComment({ ...repo, comment_id: c.id });
  }
};
