# Simple addition of one string value

[DRY]: https://en.wikipedia.org/wiki/Don%27t_repeat_yourself

Suppose you have several distinct cloud _projects_
(on GCP or AWS or whatever) named:

* cat-111
* dog-222
* fox-333

These might be project names within the company,
cloud billing identifiers, or both.

Further suppose

* You want to deploy these projects to different
  k8s namespaces, named after the projects.

* You need to specify the project name
  in various resource subfields.

* You want to name the configuration
  directories using the project name.

Additionally you might want to deploy the
projects one at a time, or all at once.

Ideally, you'll want to avoid specifying
the project name in more than one place
(i.e. you want to stay [DRY]).