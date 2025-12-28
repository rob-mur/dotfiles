{ ... }: let

  name = "robm";                       # user name
  group = "users";                        # group name
  email = "rmurphyswimmer@gmail.com";          # email
  fullname = "Rob Murphy"; # your fullname

in {

  inherit name;
  inherit group;
  inherit email;
  inherit fullname;
}
