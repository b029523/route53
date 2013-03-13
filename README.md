Description
===========

Updates Amazon Web Service's Route 53 (DNS) service. Modified to use IAM credentials

Requirements
============

An Amazon Web Services account and a Route 53 zone, and EC2 nodes configured to access
AWS API endpoints via IAM Roles

Usage
=====

```ruby
include_recipe "route53"

route53_record "create a record" do
  name  "test.opscode.com."
  value "16.8.4.2"
  type  "A"

  domain with_trailing_dot(node[:some_key])
  overwrite false

  action :create
end
```

License
=======
Copyright 2011, Heavy Water Software Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

