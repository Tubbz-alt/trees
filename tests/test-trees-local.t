Enable the extension; the path to it should be in $EXTENSION_PY.

  $ { echo '[extensions]'; echo "trees=$EXTENSION_PY"; } >> $HGRCPATH
  $ { echo '[trees]'; echo 's135 = s1 s3 s5'; } >> $HGRCPATH

Create test repos.

  $ for r in rflat rflat/s1 rflat/s2 rflat/s3 rflat/s4 rflat/s5 rflat/s6 \
  > r1 r1/s1 'r1/s1/s1.1 with spaces' r1/s1/s1.2 'r1/s1/s1.3 with spaces' \
  > r1/s2 r1/s2/s2.1 r1/s2/s2.2 r1/s2/s2.2/s2.2.1
  > do
  >     hg init "$r"
  >     echo "$r" > "$r/x" && hg -R "$r" ci -qAm "$r"
  > done
  $ hg tconfig -R rflat --set --walk
  $ hg tconfig -R r1    --set s1 s2
  $ hg tconfig -R r1/s1 --set 's1.1 with spaces' s1.2 's1.3 with spaces'
  $ hg tconfig -R r1/s2 --set --walk

  $ hg tclone -q r1 r2
  $ hg tclone -q r1 r3 s1 file:$TESTTMP/r2 s2

Clone r4 in two steps.

  $ hg tclone r1 r4 s1
  cloning r1
  updating (to branch default|working directory) (re)
  1 files updated, 0 files merged, 0 files removed, 0 files unresolved
  created $TESTTMP/r4
  
  cloning $TESTTMP/r1/s1
  updating (to branch default|working directory) (re)
  1 files updated, 0 files merged, 0 files removed, 0 files unresolved
  created $TESTTMP/r4/s1
  
  cloning $TESTTMP/r1/s1/s1.1 with spaces
  updating (to branch default|working directory) (re)
  1 files updated, 0 files merged, 0 files removed, 0 files unresolved
  created $TESTTMP/r4/s1/s1.1 with spaces
  
  cloning $TESTTMP/r1/s1/s1.2
  updating (to branch default|working directory) (re)
  1 files updated, 0 files merged, 0 files removed, 0 files unresolved
  created $TESTTMP/r4/s1/s1.2
  
  cloning $TESTTMP/r1/s1/s1.3 with spaces
  updating (to branch default|working directory) (re)
  1 files updated, 0 files merged, 0 files removed, 0 files unresolved
  created $TESTTMP/r4/s1/s1.3 with spaces

  $ hg tclone r3 r4 s2
  skipping r3 (destination exists)
  
  cloning $TESTTMP/r3/s2
  updating (to branch default|working directory) (re)
  1 files updated, 0 files merged, 0 files removed, 0 files unresolved
  created $TESTTMP/r4/s2
  
  cloning $TESTTMP/r3/s2/s2.1
  updating (to branch default|working directory) (re)
  1 files updated, 0 files merged, 0 files removed, 0 files unresolved
  created $TESTTMP/r4/s2/s2.1
  
  cloning $TESTTMP/r3/s2/s2.2
  updating (to branch default|working directory) (re)
  1 files updated, 0 files merged, 0 files removed, 0 files unresolved
  created $TESTTMP/r4/s2/s2.2
  
  cloning $TESTTMP/r3/s2/s2.2/s2.2.1
  updating (to branch default|working directory) (re)
  1 files updated, 0 files merged, 0 files removed, 0 files unresolved
  created $TESTTMP/r4/s2/s2.2/s2.2.1

Clone without explicitly listing subtrees.

  $ hg tclone r1/s1 rx
  cloning r1/s1
  updating (to branch default|working directory) (re)
  1 files updated, 0 files merged, 0 files removed, 0 files unresolved
  created $TESTTMP/rx
  
  cloning $TESTTMP/r1/s1/s1.1 with spaces
  updating (to branch default|working directory) (re)
  1 files updated, 0 files merged, 0 files removed, 0 files unresolved
  created $TESTTMP/rx/s1.1 with spaces
  
  cloning $TESTTMP/r1/s1/s1.2
  updating (to branch default|working directory) (re)
  1 files updated, 0 files merged, 0 files removed, 0 files unresolved
  created $TESTTMP/rx/s1.2
  
  cloning $TESTTMP/r1/s1/s1.3 with spaces
  updating (to branch default|working directory) (re)
  1 files updated, 0 files merged, 0 files removed, 0 files unresolved
  created $TESTTMP/rx/s1.3 with spaces

  $ hg tclone rflat rx
  skipping rflat (destination exists)
  
  cloning $TESTTMP/rflat/s1
  updating (to branch default|working directory) (re)
  1 files updated, 0 files merged, 0 files removed, 0 files unresolved
  created $TESTTMP/rx/s1
  
  cloning $TESTTMP/rflat/s2
  updating (to branch default|working directory) (re)
  1 files updated, 0 files merged, 0 files removed, 0 files unresolved
  created $TESTTMP/rx/s2
  
  cloning $TESTTMP/rflat/s3
  updating (to branch default|working directory) (re)
  1 files updated, 0 files merged, 0 files removed, 0 files unresolved
  created $TESTTMP/rx/s3
  
  cloning $TESTTMP/rflat/s4
  updating (to branch default|working directory) (re)
  1 files updated, 0 files merged, 0 files removed, 0 files unresolved
  created $TESTTMP/rx/s4
  
  cloning $TESTTMP/rflat/s5
  updating (to branch default|working directory) (re)
  1 files updated, 0 files merged, 0 files removed, 0 files unresolved
  created $TESTTMP/rx/s5
  
  cloning $TESTTMP/rflat/s6
  updating (to branch default|working directory) (re)
  1 files updated, 0 files merged, 0 files removed, 0 files unresolved
  created $TESTTMP/rx/s6

Clone with skiproot where the source is not a repository.

  $ mkdir not-a-repo
  $ hg init not-a-repo/x1
  $ hg init not-a-repo/x2
  $ hg tclone --skiproot not-a-repo rx x1 x2
  skipping root not-a-repo
  
  cloning not-a-repo/x1
  updating (to branch default|working directory) (re)
  0 files updated, 0 files merged, 0 files removed, 0 files unresolved
  created $TESTTMP/rx/x1
  
  cloning not-a-repo/x2
  updating (to branch default|working directory) (re)
  0 files updated, 0 files merged, 0 files removed, 0 files unresolved
  created $TESTTMP/rx/x2

List the configuration.

  $ hg tconfig -R rflat
  s1
  s2
  s3
  s4
  s5
  s6

  $ hg tconfig -R r1
  s1
  s2

  $ hg tconfig -R rx
  s1.1 with spaces
  s1.2
  s1.3 with spaces
  s1
  s2
  s3
  s4
  s5
  s6
  x1
  x2

  $ for r in r1 r2 r3 r4
  > do
  >     echo
  >     hg tlist -R $r
  >     hg tpaths -R $r
  > done
  
  $TESTTMP/r1
  $TESTTMP/r1/s1
  $TESTTMP/r1/s1/s1.1 with spaces
  $TESTTMP/r1/s1/s1.2
  $TESTTMP/r1/s1/s1.3 with spaces
  $TESTTMP/r1/s2
  $TESTTMP/r1/s2/s2.1
  $TESTTMP/r1/s2/s2.2
  $TESTTMP/r1/s2/s2.2/s2.2.1
  [$TESTTMP/r1]:
  
  [$TESTTMP/r1/s1]:
  
  [$TESTTMP/r1/s1/s1.1 with spaces]:
  
  [$TESTTMP/r1/s1/s1.2]:
  
  [$TESTTMP/r1/s1/s1.3 with spaces]:
  
  [$TESTTMP/r1/s2]:
  
  [$TESTTMP/r1/s2/s2.1]:
  
  [$TESTTMP/r1/s2/s2.2]:
  
  [$TESTTMP/r1/s2/s2.2/s2.2.1]:
  
  $TESTTMP/r2
  $TESTTMP/r2/s1
  $TESTTMP/r2/s1/s1.1 with spaces
  $TESTTMP/r2/s1/s1.2
  $TESTTMP/r2/s1/s1.3 with spaces
  $TESTTMP/r2/s2
  $TESTTMP/r2/s2/s2.1
  $TESTTMP/r2/s2/s2.2
  $TESTTMP/r2/s2/s2.2/s2.2.1
  [$TESTTMP/r2]:
  default = $TESTTMP/r1
  
  [$TESTTMP/r2/s1]:
  default = $TESTTMP/r1/s1
  
  [$TESTTMP/r2/s1/s1.1 with spaces]:
  default = $TESTTMP/r1/s1/s1.1 with spaces
  
  [$TESTTMP/r2/s1/s1.2]:
  default = $TESTTMP/r1/s1/s1.2
  
  [$TESTTMP/r2/s1/s1.3 with spaces]:
  default = $TESTTMP/r1/s1/s1.3 with spaces
  
  [$TESTTMP/r2/s2]:
  default = $TESTTMP/r1/s2
  
  [$TESTTMP/r2/s2/s2.1]:
  default = $TESTTMP/r1/s2/s2.1
  
  [$TESTTMP/r2/s2/s2.2]:
  default = $TESTTMP/r1/s2/s2.2
  
  [$TESTTMP/r2/s2/s2.2/s2.2.1]:
  default = $TESTTMP/r1/s2/s2.2/s2.2.1
  
  $TESTTMP/r3
  $TESTTMP/r3/s1
  $TESTTMP/r3/s1/s1.1 with spaces
  $TESTTMP/r3/s1/s1.2
  $TESTTMP/r3/s1/s1.3 with spaces
  $TESTTMP/r3/s2
  $TESTTMP/r3/s2/s2.1
  $TESTTMP/r3/s2/s2.2
  $TESTTMP/r3/s2/s2.2/s2.2.1
  [$TESTTMP/r3]:
  default = $TESTTMP/r1
  
  [$TESTTMP/r3/s1]:
  default = $TESTTMP/r1/s1
  
  [$TESTTMP/r3/s1/s1.1 with spaces]:
  default = $TESTTMP/r1/s1/s1.1 with spaces
  
  [$TESTTMP/r3/s1/s1.2]:
  default = $TESTTMP/r1/s1/s1.2
  
  [$TESTTMP/r3/s1/s1.3 with spaces]:
  default = $TESTTMP/r1/s1/s1.3 with spaces
  
  [$TESTTMP/r3/s2]:
  default = $TESTTMP/r2/s2
  
  [$TESTTMP/r3/s2/s2.1]:
  default = $TESTTMP/r2/s2/s2.1
  
  [$TESTTMP/r3/s2/s2.2]:
  default = $TESTTMP/r2/s2/s2.2
  
  [$TESTTMP/r3/s2/s2.2/s2.2.1]:
  default = $TESTTMP/r2/s2/s2.2/s2.2.1
  
  $TESTTMP/r4
  $TESTTMP/r4/s1
  $TESTTMP/r4/s1/s1.1 with spaces
  $TESTTMP/r4/s1/s1.2
  $TESTTMP/r4/s1/s1.3 with spaces
  $TESTTMP/r4/s2
  $TESTTMP/r4/s2/s2.1
  $TESTTMP/r4/s2/s2.2
  $TESTTMP/r4/s2/s2.2/s2.2.1
  [$TESTTMP/r4]:
  default = $TESTTMP/r1
  
  [$TESTTMP/r4/s1]:
  default = $TESTTMP/r1/s1
  
  [$TESTTMP/r4/s1/s1.1 with spaces]:
  default = $TESTTMP/r1/s1/s1.1 with spaces
  
  [$TESTTMP/r4/s1/s1.2]:
  default = $TESTTMP/r1/s1/s1.2
  
  [$TESTTMP/r4/s1/s1.3 with spaces]:
  default = $TESTTMP/r1/s1/s1.3 with spaces
  
  [$TESTTMP/r4/s2]:
  default = $TESTTMP/r3/s2
  
  [$TESTTMP/r4/s2/s2.1]:
  default = $TESTTMP/r3/s2/s2.1
  
  [$TESTTMP/r4/s2/s2.2]:
  default = $TESTTMP/r3/s2/s2.2
  
  [$TESTTMP/r4/s2/s2.2/s2.2.1]:
  default = $TESTTMP/r3/s2/s2.2/s2.2.1

Test tconfig command.

  $ hg init r4/s3
  $ hg tconfig -R r4
  s1
  s2

  $ hg tconfig -R r4 -a s3
  $ hg tconfig -R r4
  s1
  s2
  s3
  $ hg tconfig -R r4 -a s3 # should fail
  abort: subtree s3 already configured
  [255]
  $ hg tconfig -R r4 -d s0 # should fail
  abort: no subtree s0
  [255]

  $ hg tconfig -R r4 -s s1 s2
  $ hg tconfig -R r4
  s1
  s2

  $ hg tconfig -R r4 -s # should fail
  abort: * (glob)
  [255]
  $ hg tconfig -R r4 -d --all
  $ hg tconfig -R r4

  $ hg tconfig -R r4 -s s1 s2 s3
  $ hg tconfig -R r4
  s1
  s2
  s3

  $ hg tconfig -R r4 -d s1
  $ hg tconfig -R r4
  s2
  s3

  $ hg tconfig -R r4 -s s1 s2
  $ hg tconfig -R r4
  s1
  s2

  $ hg tlist -R r4
  $TESTTMP/r4
  $TESTTMP/r4/s1
  $TESTTMP/r4/s1/s1.1 with spaces
  $TESTTMP/r4/s1/s1.2
  $TESTTMP/r4/s1/s1.3 with spaces
  $TESTTMP/r4/s2
  $TESTTMP/r4/s2/s2.1
  $TESTTMP/r4/s2/s2.2
  $TESTTMP/r4/s2/s2.2/s2.2.1
  $ hg tlist -R r4 -w
  $TESTTMP/r4
  $TESTTMP/r4/s1
  $TESTTMP/r4/s1/s1.1 with spaces
  $TESTTMP/r4/s1/s1.2
  $TESTTMP/r4/s1/s1.3 with spaces
  $TESTTMP/r4/s2
  $TESTTMP/r4/s2/s2.1
  $TESTTMP/r4/s2/s2.2
  $TESTTMP/r4/s2/s2.2/s2.2.1
  $TESTTMP/r4/s3

  $ cat <<EOF >> r4/s3/.hg/hgrc
  > [trees]
  > tlevel0 = t0
  > tlevel1 = tlevel0 t1 t2 t3
  > tlevel2 = tlevel1 t4 t5
  > tlevelx = x tlevel1 y z
  > EOF
  $ hg -R r4/s3 tconfig --expand tlevel0
  t0
  $ hg -R r4/s3 tconfig --expand tlevel1
  t0 t1 t2 t3
  $ hg -R r4/s3 tconfig --expand tlevel2
  t0 t1 t2 t3 t4 t5
  $ hg -R r4/s3 tconfig --expand tlevelx
  x t0 t1 t2 t3 y z

  $ rm -r r4/s3

Create changesets in r1 and r2.

  $ for r in r1 r2
  > do
  >     for sr in s2 s2/s2.2 s2/s2.2/s2.2.1
  >     do
  >         echo $sr > $r/$sr/file.$r
  >         hg -R $r/$sr add $r/$sr/file.$r
  >         hg -R $r/$sr ci -qm "$r/$sr/file.$r"
  >     done
  > done

Check incoming & outgoing

  $ hg -R r1 tin r2
  [$TESTTMP/r1]:
  comparing with r2
  searching for changes
  no changes found
  
  [$TESTTMP/r1/s1]:
  comparing with r2/s1
  searching for changes
  no changes found
  
  [$TESTTMP/r1/s1/s1.1 with spaces]:
  comparing with r2/s1/s1.1 with spaces
  searching for changes
  no changes found
  
  [$TESTTMP/r1/s1/s1.2]:
  comparing with r2/s1/s1.2
  searching for changes
  no changes found
  
  [$TESTTMP/r1/s1/s1.3 with spaces]:
  comparing with r2/s1/s1.3 with spaces
  searching for changes
  no changes found
  
  [$TESTTMP/r1/s2]:
  comparing with r2/s2
  searching for changes
  changeset:   1:02ac722f677c
  tag:         tip
  user:        test
  date:        Thu Jan 01 00:00:00 1970 +0000
  summary:     r2/s2/file.r2
  
  
  [$TESTTMP/r1/s2/s2.1]:
  comparing with r2/s2/s2.1
  searching for changes
  no changes found
  
  [$TESTTMP/r1/s2/s2.2]:
  comparing with r2/s2/s2.2
  searching for changes
  changeset:   1:b9139c2dc588
  tag:         tip
  user:        test
  date:        Thu Jan 01 00:00:00 1970 +0000
  summary:     r2/s2/s2.2/file.r2
  
  
  [$TESTTMP/r1/s2/s2.2/s2.2.1]:
  comparing with r2/s2/s2.2/s2.2.1
  searching for changes
  changeset:   1:c0662346bf9f
  tag:         tip
  user:        test
  date:        Thu Jan 01 00:00:00 1970 +0000
  summary:     r2/s2/s2.2/s2.2.1/file.r2
  
  $ hg -R r2 tin
  [$TESTTMP/r2]:
  comparing with $TESTTMP/r1
  searching for changes
  no changes found
  
  [$TESTTMP/r2/s1]:
  comparing with $TESTTMP/r1/s1
  searching for changes
  no changes found
  
  [$TESTTMP/r2/s1/s1.1 with spaces]:
  comparing with $TESTTMP/r1/s1/s1.1 with spaces
  searching for changes
  no changes found
  
  [$TESTTMP/r2/s1/s1.2]:
  comparing with $TESTTMP/r1/s1/s1.2
  searching for changes
  no changes found
  
  [$TESTTMP/r2/s1/s1.3 with spaces]:
  comparing with $TESTTMP/r1/s1/s1.3 with spaces
  searching for changes
  no changes found
  
  [$TESTTMP/r2/s2]:
  comparing with $TESTTMP/r1/s2
  searching for changes
  changeset:   1:e87282477f23
  tag:         tip
  user:        test
  date:        Thu Jan 01 00:00:00 1970 +0000
  summary:     r1/s2/file.r1
  
  
  [$TESTTMP/r2/s2/s2.1]:
  comparing with $TESTTMP/r1/s2/s2.1
  searching for changes
  no changes found
  
  [$TESTTMP/r2/s2/s2.2]:
  comparing with $TESTTMP/r1/s2/s2.2
  searching for changes
  changeset:   1:19c35aa89db4
  tag:         tip
  user:        test
  date:        Thu Jan 01 00:00:00 1970 +0000
  summary:     r1/s2/s2.2/file.r1
  
  
  [$TESTTMP/r2/s2/s2.2/s2.2.1]:
  comparing with $TESTTMP/r1/s2/s2.2/s2.2.1
  searching for changes
  changeset:   1:0830ec9a3521
  tag:         tip
  user:        test
  date:        Thu Jan 01 00:00:00 1970 +0000
  summary:     r1/s2/s2.2/s2.2.1/file.r1
  
  $ hg -R r1 tout r2
  [$TESTTMP/r1]:
  comparing with r2
  searching for changes
  no changes found
  
  [$TESTTMP/r1/s1]:
  comparing with r2/s1
  searching for changes
  no changes found
  
  [$TESTTMP/r1/s1/s1.1 with spaces]:
  comparing with r2/s1/s1.1 with spaces
  searching for changes
  no changes found
  
  [$TESTTMP/r1/s1/s1.2]:
  comparing with r2/s1/s1.2
  searching for changes
  no changes found
  
  [$TESTTMP/r1/s1/s1.3 with spaces]:
  comparing with r2/s1/s1.3 with spaces
  searching for changes
  no changes found
  
  [$TESTTMP/r1/s2]:
  comparing with r2/s2
  searching for changes
  changeset:   1:e87282477f23
  tag:         tip
  user:        test
  date:        Thu Jan 01 00:00:00 1970 +0000
  summary:     r1/s2/file.r1
  
  
  [$TESTTMP/r1/s2/s2.1]:
  comparing with r2/s2/s2.1
  searching for changes
  no changes found
  
  [$TESTTMP/r1/s2/s2.2]:
  comparing with r2/s2/s2.2
  searching for changes
  changeset:   1:19c35aa89db4
  tag:         tip
  user:        test
  date:        Thu Jan 01 00:00:00 1970 +0000
  summary:     r1/s2/s2.2/file.r1
  
  
  [$TESTTMP/r1/s2/s2.2/s2.2.1]:
  comparing with r2/s2/s2.2/s2.2.1
  searching for changes
  changeset:   1:0830ec9a3521
  tag:         tip
  user:        test
  date:        Thu Jan 01 00:00:00 1970 +0000
  summary:     r1/s2/s2.2/s2.2.1/file.r1
  
  $ hg -R r2 tout
  [$TESTTMP/r2]:
  comparing with $TESTTMP/r1
  searching for changes
  no changes found
  
  [$TESTTMP/r2/s1]:
  comparing with $TESTTMP/r1/s1
  searching for changes
  no changes found
  
  [$TESTTMP/r2/s1/s1.1 with spaces]:
  comparing with $TESTTMP/r1/s1/s1.1 with spaces
  searching for changes
  no changes found
  
  [$TESTTMP/r2/s1/s1.2]:
  comparing with $TESTTMP/r1/s1/s1.2
  searching for changes
  no changes found
  
  [$TESTTMP/r2/s1/s1.3 with spaces]:
  comparing with $TESTTMP/r1/s1/s1.3 with spaces
  searching for changes
  no changes found
  
  [$TESTTMP/r2/s2]:
  comparing with $TESTTMP/r1/s2
  searching for changes
  changeset:   1:02ac722f677c
  tag:         tip
  user:        test
  date:        Thu Jan 01 00:00:00 1970 +0000
  summary:     r2/s2/file.r2
  
  
  [$TESTTMP/r2/s2/s2.1]:
  comparing with $TESTTMP/r1/s2/s2.1
  searching for changes
  no changes found
  
  [$TESTTMP/r2/s2/s2.2]:
  comparing with $TESTTMP/r1/s2/s2.2
  searching for changes
  changeset:   1:b9139c2dc588
  tag:         tip
  user:        test
  date:        Thu Jan 01 00:00:00 1970 +0000
  summary:     r2/s2/s2.2/file.r2
  
  
  [$TESTTMP/r2/s2/s2.2/s2.2.1]:
  comparing with $TESTTMP/r1/s2/s2.2/s2.2.1
  searching for changes
  changeset:   1:c0662346bf9f
  tag:         tip
  user:        test
  date:        Thu Jan 01 00:00:00 1970 +0000
  summary:     r2/s2/s2.2/s2.2.1/file.r2
  

Pull, merge, push.

  $ hg -R r2 tpull
  [$TESTTMP/r2]:
  pulling from $TESTTMP/r1
  searching for changes
  no changes found
  
  [$TESTTMP/r2/s1]:
  pulling from $TESTTMP/r1/s1
  searching for changes
  no changes found
  
  [$TESTTMP/r2/s1/s1.1 with spaces]:
  pulling from $TESTTMP/r1/s1/s1.1 with spaces
  searching for changes
  no changes found
  
  [$TESTTMP/r2/s1/s1.2]:
  pulling from $TESTTMP/r1/s1/s1.2
  searching for changes
  no changes found
  
  [$TESTTMP/r2/s1/s1.3 with spaces]:
  pulling from $TESTTMP/r1/s1/s1.3 with spaces
  searching for changes
  no changes found
  
  [$TESTTMP/r2/s2]:
  pulling from $TESTTMP/r1/s2
  searching for changes
  adding changesets
  adding manifests
  adding file changes
  added 1 changesets with 1 changes to 1 files (+1 heads)
  new changesets e87282477f23 (?)
  (run 'hg heads' to see heads, 'hg merge' to merge)
  
  [$TESTTMP/r2/s2/s2.1]:
  pulling from $TESTTMP/r1/s2/s2.1
  searching for changes
  no changes found
  
  [$TESTTMP/r2/s2/s2.2]:
  pulling from $TESTTMP/r1/s2/s2.2
  searching for changes
  adding changesets
  adding manifests
  adding file changes
  added 1 changesets with 1 changes to 1 files (+1 heads)
  new changesets 19c35aa89db4 (?)
  (run 'hg heads' to see heads, 'hg merge' to merge)
  
  [$TESTTMP/r2/s2/s2.2/s2.2.1]:
  pulling from $TESTTMP/r1/s2/s2.2/s2.2.1
  searching for changes
  adding changesets
  adding manifests
  adding file changes
  added 1 changesets with 1 changes to 1 files (+1 heads)
  new changesets 0830ec9a3521 (?)
  (run 'hg heads' to see heads, 'hg merge' to merge)
  $ hg -R r2 tmerge
  [$TESTTMP/r2]:
  nothing to merge
  
  [$TESTTMP/r2/s1]:
  nothing to merge
  
  [$TESTTMP/r2/s1/s1.1 with spaces]:
  nothing to merge
  
  [$TESTTMP/r2/s1/s1.2]:
  nothing to merge
  
  [$TESTTMP/r2/s1/s1.3 with spaces]:
  nothing to merge
  
  [$TESTTMP/r2/s2]:
  1 files updated, 0 files merged, 0 files removed, 0 files unresolved
  (branch merge, don't forget to commit)
  
  [$TESTTMP/r2/s2/s2.1]:
  nothing to merge
  
  [$TESTTMP/r2/s2/s2.2]:
  1 files updated, 0 files merged, 0 files removed, 0 files unresolved
  (branch merge, don't forget to commit)
  
  [$TESTTMP/r2/s2/s2.2/s2.2.1]:
  1 files updated, 0 files merged, 0 files removed, 0 files unresolved
  (branch merge, don't forget to commit)
  $ hg -R r2 tcommit -d '0 0' -m 'merge with r1'
  [$TESTTMP/r2]:
  nothing to commit
  
  [$TESTTMP/r2/s1]:
  nothing to commit
  
  [$TESTTMP/r2/s1/s1.1 with spaces]:
  nothing to commit
  
  [$TESTTMP/r2/s1/s1.2]:
  nothing to commit
  
  [$TESTTMP/r2/s1/s1.3 with spaces]:
  nothing to commit
  
  [$TESTTMP/r2/s2]:
  
  [$TESTTMP/r2/s2/s2.1]:
  nothing to commit
  
  [$TESTTMP/r2/s2/s2.2]:
  
  [$TESTTMP/r2/s2/s2.2/s2.2.1]:
  $ hg -R r2 tpush
  [$TESTTMP/r2]:
  pushing to $TESTTMP/r1
  searching for changes
  no changes found
  
  [$TESTTMP/r2/s1]:
  pushing to $TESTTMP/r1/s1
  searching for changes
  no changes found
  
  [$TESTTMP/r2/s1/s1.1 with spaces]:
  pushing to $TESTTMP/r1/s1/s1.1 with spaces
  searching for changes
  no changes found
  
  [$TESTTMP/r2/s1/s1.2]:
  pushing to $TESTTMP/r1/s1/s1.2
  searching for changes
  no changes found
  
  [$TESTTMP/r2/s1/s1.3 with spaces]:
  pushing to $TESTTMP/r1/s1/s1.3 with spaces
  searching for changes
  no changes found
  
  [$TESTTMP/r2/s2]:
  pushing to $TESTTMP/r1/s2
  searching for changes
  adding changesets
  adding manifests
  adding file changes
  added 2 changesets with 1 changes to 1 files
  
  [$TESTTMP/r2/s2/s2.1]:
  pushing to $TESTTMP/r1/s2/s2.1
  searching for changes
  no changes found
  
  [$TESTTMP/r2/s2/s2.2]:
  pushing to $TESTTMP/r1/s2/s2.2
  searching for changes
  adding changesets
  adding manifests
  adding file changes
  added 2 changesets with 1 changes to 1 files
  
  [$TESTTMP/r2/s2/s2.2/s2.2.1]:
  pushing to $TESTTMP/r1/s2/s2.2/s2.2.1
  searching for changes
  adding changesets
  adding manifests
  adding file changes
  added 2 changesets with 1 changes to 1 files

  $ hg -R r1 ttip
  [$TESTTMP/r1]:
  changeset:   0:8d066171e5de
  tag:         tip
  user:        test
  date:        Thu Jan 01 00:00:00 1970 +0000
  summary:     r1
  
  
  [$TESTTMP/r1/s1]:
  changeset:   0:30b4bf8cd1c5
  tag:         tip
  user:        test
  date:        Thu Jan 01 00:00:00 1970 +0000
  summary:     r1/s1
  
  
  [$TESTTMP/r1/s1/s1.1 with spaces]:
  changeset:   0:898fb1dda185
  tag:         tip
  user:        test
  date:        Thu Jan 01 00:00:00 1970 +0000
  summary:     r1/s1/s1.1 with spaces
  
  
  [$TESTTMP/r1/s1/s1.2]:
  changeset:   0:7457850caaf5
  tag:         tip
  user:        test
  date:        Thu Jan 01 00:00:00 1970 +0000
  summary:     r1/s1/s1.2
  
  
  [$TESTTMP/r1/s1/s1.3 with spaces]:
  changeset:   0:7c1472d16a1f
  tag:         tip
  user:        test
  date:        Thu Jan 01 00:00:00 1970 +0000
  summary:     r1/s1/s1.3 with spaces
  
  
  [$TESTTMP/r1/s2]:
  changeset:   3:3d0a1cb52bf2
  tag:         tip
  parent:      2:02ac722f677c
  parent:      1:e87282477f23
  user:        test
  date:        Thu Jan 01 00:00:00 1970 +0000
  summary:     merge with r1
  
  
  [$TESTTMP/r1/s2/s2.1]:
  changeset:   0:ed63cc458a75
  tag:         tip
  user:        test
  date:        Thu Jan 01 00:00:00 1970 +0000
  summary:     r1/s2/s2.1
  
  
  [$TESTTMP/r1/s2/s2.2]:
  changeset:   3:76fc250030c4
  tag:         tip
  parent:      2:b9139c2dc588
  parent:      1:19c35aa89db4
  user:        test
  date:        Thu Jan 01 00:00:00 1970 +0000
  summary:     merge with r1
  
  
  [$TESTTMP/r1/s2/s2.2/s2.2.1]:
  changeset:   3:015d691fdafe
  tag:         tip
  parent:      2:c0662346bf9f
  parent:      1:0830ec9a3521
  user:        test
  date:        Thu Jan 01 00:00:00 1970 +0000
  summary:     merge with r1
  
Run tin & tout again (should be nothing incoming) to check exit code.

  $ hg -R r2 tin
  [$TESTTMP/r2]:
  comparing with $TESTTMP/r1
  searching for changes
  no changes found
  
  [$TESTTMP/r2/s1]:
  comparing with $TESTTMP/r1/s1
  searching for changes
  no changes found
  
  [$TESTTMP/r2/s1/s1.1 with spaces]:
  comparing with $TESTTMP/r1/s1/s1.1 with spaces
  searching for changes
  no changes found
  
  [$TESTTMP/r2/s1/s1.2]:
  comparing with $TESTTMP/r1/s1/s1.2
  searching for changes
  no changes found
  
  [$TESTTMP/r2/s1/s1.3 with spaces]:
  comparing with $TESTTMP/r1/s1/s1.3 with spaces
  searching for changes
  no changes found
  
  [$TESTTMP/r2/s2]:
  comparing with $TESTTMP/r1/s2
  searching for changes
  no changes found
  
  [$TESTTMP/r2/s2/s2.1]:
  comparing with $TESTTMP/r1/s2/s2.1
  searching for changes
  no changes found
  
  [$TESTTMP/r2/s2/s2.2]:
  comparing with $TESTTMP/r1/s2/s2.2
  searching for changes
  no changes found
  
  [$TESTTMP/r2/s2/s2.2/s2.2.1]:
  comparing with $TESTTMP/r1/s2/s2.2/s2.2.1
  searching for changes
  no changes found
  [1]
  $ hg -R r2 tout -q
  [1]

Test tree aliases.

  $ hg tclone rflat r135 s135
  cloning rflat
  updating (to branch default|working directory) (re)
  1 files updated, 0 files merged, 0 files removed, 0 files unresolved
  created $TESTTMP/r135
  
  cloning $TESTTMP/rflat/s1
  updating (to branch default|working directory) (re)
  1 files updated, 0 files merged, 0 files removed, 0 files unresolved
  created $TESTTMP/r135/s1
  
  cloning $TESTTMP/rflat/s3
  updating (to branch default|working directory) (re)
  1 files updated, 0 files merged, 0 files removed, 0 files unresolved
  created $TESTTMP/r135/s3
  
  cloning $TESTTMP/rflat/s5
  updating (to branch default|working directory) (re)
  1 files updated, 0 files merged, 0 files removed, 0 files unresolved
  created $TESTTMP/r135/s5
  $ hg tpaths -R r135
  [$TESTTMP/r135]:
  default = $TESTTMP/rflat
  
  [$TESTTMP/r135/s1]:
  default = $TESTTMP/rflat/s1
  
  [$TESTTMP/r135/s3]:
  default = $TESTTMP/rflat/s3
  
  [$TESTTMP/r135/s5]:
  default = $TESTTMP/rflat/s5

Test tcommand, tparents, tstatus, ttag, tupdate.

  $ hg tlist -R r135
  $TESTTMP/r135
  $TESTTMP/r135/s1
  $TESTTMP/r135/s3
  $TESTTMP/r135/s5
  $ hg tcommand -R r135 pwd
  [$TESTTMP/r135]:
  $TESTTMP/r135
  
  [$TESTTMP/r135/s1]:
  $TESTTMP/r135/s1
  
  [$TESTTMP/r135/s3]:
  $TESTTMP/r135/s3
  
  [$TESTTMP/r135/s5]:
  $TESTTMP/r135/s5
  $ hg tstat -R r135 -q
  $ hg tcommand -R r135 -q -- sh -c 'echo foo > xyz'
  $ hg tstat -R r135
  [$TESTTMP/r135]:
  ? xyz
  
  [$TESTTMP/r135/s1]:
  ? xyz
  
  [$TESTTMP/r135/s3]:
  ? xyz
  
  [$TESTTMP/r135/s5]:
  ? xyz
  $ hg tcommand -R r135 -q -- hg add xyz
  $ hg tstat -R r135
  [$TESTTMP/r135]:
  A xyz
  
  [$TESTTMP/r135/s1]:
  A xyz
  
  [$TESTTMP/r135/s3]:
  A xyz
  
  [$TESTTMP/r135/s5]:
  A xyz
  $ hg tdiff -R r135 --nodates
  [$TESTTMP/r135]:
  diff -r cb6a7267a0e3 xyz
  --- /dev/null
  +++ b/xyz
  @@ -0,0 +1,1 @@
  +foo
  
  [$TESTTMP/r135/s1]:
  diff -r 5be808557fcc xyz
  --- /dev/null
  +++ b/xyz
  @@ -0,0 +1,1 @@
  +foo
  
  [$TESTTMP/r135/s3]:
  diff -r 16d0c651073b xyz
  --- /dev/null
  +++ b/xyz
  @@ -0,0 +1,1 @@
  +foo
  
  [$TESTTMP/r135/s5]:
  diff -r 87710fdf686c xyz
  --- /dev/null
  +++ b/xyz
  @@ -0,0 +1,1 @@
  +foo
  $ hg tcommit -R r135 -d '0 0' -q -m 'add xyz'
  $ hg tstat -R r135 -q
  $ hg ttag  -R r135 -d '0 0' xyz
  [$TESTTMP/r135]:
  
  [$TESTTMP/r135/s1]:
  
  [$TESTTMP/r135/s3]:
  
  [$TESTTMP/r135/s5]:
  $ hg tlog  -R r135 -l 2
  [$TESTTMP/r135]:
  changeset:   2:4ced22f7af69
  tag:         tip
  user:        test
  date:        Thu Jan 01 00:00:00 1970 +0000
  summary:     Added tag xyz for changeset 7daa537724f7
  
  changeset:   1:7daa537724f7
  tag:         xyz
  user:        test
  date:        Thu Jan 01 00:00:00 1970 +0000
  summary:     add xyz
  
  
  [$TESTTMP/r135/s1]:
  changeset:   2:4031d5de603a
  tag:         tip
  user:        test
  date:        Thu Jan 01 00:00:00 1970 +0000
  summary:     Added tag xyz for changeset 7ee3e2b9a80f
  
  changeset:   1:7ee3e2b9a80f
  tag:         xyz
  user:        test
  date:        Thu Jan 01 00:00:00 1970 +0000
  summary:     add xyz
  
  
  [$TESTTMP/r135/s3]:
  changeset:   2:75a448015ccf
  tag:         tip
  user:        test
  date:        Thu Jan 01 00:00:00 1970 +0000
  summary:     Added tag xyz for changeset e0644cb753a1
  
  changeset:   1:e0644cb753a1
  tag:         xyz
  user:        test
  date:        Thu Jan 01 00:00:00 1970 +0000
  summary:     add xyz
  
  
  [$TESTTMP/r135/s5]:
  changeset:   2:764efa1ac652
  tag:         tip
  user:        test
  date:        Thu Jan 01 00:00:00 1970 +0000
  summary:     Added tag xyz for changeset 3abbfd61fcf3
  
  changeset:   1:3abbfd61fcf3
  tag:         xyz
  user:        test
  date:        Thu Jan 01 00:00:00 1970 +0000
  summary:     add xyz
  
  $ hg tup   -R r135 1
  [$TESTTMP/r135]:
  0 files updated, 0 files merged, 1 files removed, 0 files unresolved
  
  [$TESTTMP/r135/s1]:
  0 files updated, 0 files merged, 1 files removed, 0 files unresolved
  
  [$TESTTMP/r135/s3]:
  0 files updated, 0 files merged, 1 files removed, 0 files unresolved
  
  [$TESTTMP/r135/s5]:
  0 files updated, 0 files merged, 1 files removed, 0 files unresolved
  $ hg tparents -R r135
  [$TESTTMP/r135]:
  changeset:   1:7daa537724f7
  tag:         xyz
  user:        test
  date:        Thu Jan 01 00:00:00 1970 +0000
  summary:     add xyz
  
  
  [$TESTTMP/r135/s1]:
  changeset:   1:7ee3e2b9a80f
  tag:         xyz
  user:        test
  date:        Thu Jan 01 00:00:00 1970 +0000
  summary:     add xyz
  
  
  [$TESTTMP/r135/s3]:
  changeset:   1:e0644cb753a1
  tag:         xyz
  user:        test
  date:        Thu Jan 01 00:00:00 1970 +0000
  summary:     add xyz
  
  
  [$TESTTMP/r135/s5]:
  changeset:   1:3abbfd61fcf3
  tag:         xyz
  user:        test
  date:        Thu Jan 01 00:00:00 1970 +0000
  summary:     add xyz
  
  $ hg tup   -R r135
  [$TESTTMP/r135]:
  1 files updated, 0 files merged, 0 files removed, 0 files unresolved
  
  [$TESTTMP/r135/s1]:
  1 files updated, 0 files merged, 0 files removed, 0 files unresolved
  
  [$TESTTMP/r135/s3]:
  1 files updated, 0 files merged, 0 files removed, 0 files unresolved
  
  [$TESTTMP/r135/s5]:
  1 files updated, 0 files merged, 0 files removed, 0 files unresolved
  $ hg tparents -R r135
  [$TESTTMP/r135]:
  changeset:   2:4ced22f7af69
  tag:         tip
  user:        test
  date:        Thu Jan 01 00:00:00 1970 +0000
  summary:     Added tag xyz for changeset 7daa537724f7
  
  
  [$TESTTMP/r135/s1]:
  changeset:   2:4031d5de603a
  tag:         tip
  user:        test
  date:        Thu Jan 01 00:00:00 1970 +0000
  summary:     Added tag xyz for changeset 7ee3e2b9a80f
  
  
  [$TESTTMP/r135/s3]:
  changeset:   2:75a448015ccf
  tag:         tip
  user:        test
  date:        Thu Jan 01 00:00:00 1970 +0000
  summary:     Added tag xyz for changeset e0644cb753a1
  
  
  [$TESTTMP/r135/s5]:
  changeset:   2:764efa1ac652
  tag:         tip
  user:        test
  date:        Thu Jan 01 00:00:00 1970 +0000
  summary:     Added tag xyz for changeset 3abbfd61fcf3
  

Test tconfig --set --depth.

  $ for r in \
  > n1 n1/a n1/a/b/c n1/a/b/c2 n1/d n1/d/e/f/g n1/d/e/f/g/h n1/d/e/f/i \
  > n1/d/e/f/j n1/p/q/r n1/p/q/s \
  > n2 n2/a n2/a/b n2/a/b/c n2/b n2/c n2/d n2/d/e n2/d/e/f n2/d/e/f/g \
  > n2/a/b/c/c2 \
  > n3 n3/a/b/c n3/a/b/c/d n3/a/b/c/e n3/x/y n3/a/b/c/f n3/a/b/c/f/g/h \
  >   n3/x/z n3/p/q/r
  > do
  >   mkdir -p $r
  >   rmdir $r
  > 	hg init $r
  > done

  $ hg -R n1 tconfig --set --walk
  $ hg -R n1 tconfig
  a
  a/b/c
  a/b/c2
  d
  d/e/f/g
  d/e/f/g/h
  d/e/f/i
  d/e/f/j
  p/q/r
  p/q/s
  $ hg -R n1 tlist --short
  .
  a
  a/b/c
  a/b/c2
  d
  d/e/f/g
  d/e/f/g/h
  d/e/f/i
  d/e/f/j
  p/q/r
  p/q/s
  $ hg -R n1 tconfig --set --depth
  $ hg -R n1 tconfig
  a
  d
  p/q/r
  p/q/s
  $ hg -R n1 tlist --short
  .
  a
  a/b/c
  a/b/c2
  d
  d/e/f/g
  d/e/f/g/h
  d/e/f/i
  d/e/f/j
  p/q/r
  p/q/s
  $ hg -R n1/a tconfig
  b/c
  b/c2
  $ hg -R n1/d tconfig
  e/f/g
  e/f/i
  e/f/j

tconfig --set --depth with no args should be repeatable

  $ hg -R n1 tconfig --set --depth
  $ hg -R n1 tconfig
  a
  d
  p/q/r
  p/q/s
  $ hg -R n1 tlist --short
  .
  a
  a/b/c
  a/b/c2
  d
  d/e/f/g
  d/e/f/g/h
  d/e/f/i
  d/e/f/j
  p/q/r
  p/q/s

  $ hg -R n2 tconfig --set --walk --depth
  $ hg -R n2 tconfig
  a
  b
  c
  d
  $ hg -R n2 tlist --short
  .
  a
  a/b
  a/b/c
  a/b/c/c2
  b
  c
  d
  d/e
  d/e/f
  d/e/f/g
  $ hg -R n2/d tconfig
  e
  $ hg -R n2/d/e tconfig
  f
  $ hg -R n2/d/e/f tconfig
  g

  $ hg -R n3 tconfig --set --depth a/b/c a/b/c/d a/b/c/e x/y a/b/c/f \
  > a/b/c/f/g/h x/z p/q/r
  $ hg -R n3 tconfig
  a/b/c
  x/y
  x/z
  p/q/r
  $ hg -R n3 tlist --short
  .
  a/b/c
  a/b/c/d
  a/b/c/e
  a/b/c/f
  a/b/c/f/g/h
  x/y
  x/z
  p/q/r
  $ hg -R n3/a/b/c tlist --short
  .
  d
  e
  f
  f/g/h
  $ hg -R n3/a/b/c/f tlist --short
  .
  g/h
