# chef-misc
###### Miscellaneous recipes around the Erlang ecosystem.

## Applying the cookbooks

With the chefdk installed, enter the directory in which chef-misc is installed
and execute the following:

```bash
sudo chef-client -z -r "chef-misc::_common,chef-misc::default"
```
