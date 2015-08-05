# README

The formatted html version of the course project can assessed via the following URL:

- [CourseProject.html](http://technophobe01.github.io/courses/08_PracticalMachineLearning/00_Course_Work/CourseProject/CourseProject.html) 

Example Markdown Link Structure:

	[CourseProject.html](http://technophobe01.github.io/courses/08_PracticalMachineLearning/00_Course_Work/CourseProject/CourseProject.html)


## Background:

### Attribution: Patricia Ellen Tressel

The project submission instructions suggest that you can make it easier for reviewers to see your finished html output by setting up a "gh-pages" branch in your Github repository.  That will automatically create a web site for the repo on github.io, with your html page properly displayed.

The short version of this how-to is:

1. In your project repository, create a gh-pages branch that is just the same as the master branch.
1. Push the gh-pages branch to Github.
1. Wait about 5 minutes.  Poof!  Your web site is available on github.io!

So...follow on below for the "detailed" instructions, broken up into pieces:

1. How to make your gh-pages branch...
1. using git commands in your local repo.
1. right on Github itself.
1. How to maintain the gh-pages branch if you make changes to your project after creating the branch.

Plus some "extras":

3. A few other files you can provide to help people find things in your repo and github.io site.
4. Some notes on git, Github, and revision control.

You can either make the gh-pages branch by using git commands in your local repository, or by clicking buttons on Github.  First, here's how to make it using git commands -- this is the more typical case.  I'm going to describe this using git from the command line -- if you have a git GUI tool, it will have a way to make a new branch, so use that to do the equivalent of what's here.

In your command line window, change directory to your project git repository.  Create the branch and make it identical to your master branch:

	git checkout -b gh-pages

That tells Github to make new branch identical to your current branch (which I'm assuming is master) and check it out.  After that, you can push it to Github.

	git push origin gh-pages

Then switch back to master to continue working (no "-b" this time as that's for making a new branch).

	git checkout master

---
