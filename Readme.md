
# module::GitTools  [![status](https://github.com/Wandalen/wGitTools/actions/workflows/StandardPublish.yml/badge.svg)](https://github.com/Wandalen/wGitTools/actions/workflows/StandardPublish.yml) [![stable](https://img.shields.io/badge/stability-stable-brightgreen.svg)](https://github.com/emersion/stability-badges#stable)

Collection of tools to use git programmatically.

### Try out from the repository

```
git clone https://github.com/Wandalen/wGitTools
cd wGitTools
will .npm.install
node sample/trivial/Sample.s
```

Make sure you have utility `willbe` installed. To install willbe: `npm i -g willbe@stable`. Willbe is required to build of the module.

### To add to your project

```
npm add 'wgittools@stable'
```

`Willbe` is not required to use the module in your project as submodule.

### Examples

#### Status for repository

Clone any repository. For example [wTools](https://github.com/Wandalen/wTools.git).

Write script `Script.s` in the root of cloned repository :

```js
const _ = require( 'wgittools' );
let status = _.git.status
({
  localPath : __dirname,
  detailing : 1,
  explaining : 1
});

console.log( status );
/* log :
[Object: null prototype] {
  uncommitted: 'List of uncommited changes in files:\n  ?? script.s\n  M package.json',
  unpushed: false,
  uncommittedUntracked: '?? Script.s',
  uncommittedAdded: false,
  uncommittedChanged: 'M package.json',
  uncommittedDeleted: false,
  uncommittedRenamed: false,
  uncommittedCopied: false,
  uncommittedIgnored: null,
  uncommittedUnstaged: false,
  conflicts: false,
  unpushedCommits: false,
  unpushedTags: false,
  unpushedBranches: false,
  status: 'List of uncommited changes in files:\n  ?? script.s\n  M package.json',
  remoteCommits: false,
  remoteBranches: null,
  remoteTags: false,
  local: 'List of uncommited changes in files:\n  ?? script.s\n  M package.json',
  remote: false
}
*/
```

Install dependency `wgittools` by command `npm i wgittools` and then run command `node Script.s`.

Compare the output with the log above.

The status contains many information about local and remote repository including conflicts between files and unpulled changes.

The current log shows that in root directory added file `Script.s` ( `uncommittedUntracked: '?? Script.s'` ), and file `package.json` was modified.

#### Init an empty repository

Create an empty directory and add file `Script.s` with next content ( replace `USER` and `TOKEN` with your Github username and Github acces token respectively ):

```js
const _ = require( 'wgittools' );

_.git.repositoryInit
({
  remotePath : 'https://github.com/USER/Test-repo.git',
  localPath : _.path.join( __dirname, 'Test-repo' ),
  description : 'Test repository',
  token : TOKEN,
});
```

Run command `npm i wgittools` and then run script by command `node Script.s`.

Check current directory, script will create local git repository in directory `Test-repo`. Run next commands :

```bash
cd Test-repo
git remote -v
```

Output should looks like :

```bash
origin	https://github.com/USER/Test-repo.git (fetch)
origin	https://github.com/USER/Test-repo.git (push)
```

Also, check your Github repositories. The new repository `Test-repo` should exist.
