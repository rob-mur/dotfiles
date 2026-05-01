{ ... }: {
  # Pin the docker group GID so the Forgejo runner can use --group-add
  # with a numeric GID that matches across host and job containers.
  users.groups.docker.gid = 305;

  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = true;
      autoPrune = {
        enable = true;
      };
    };
  };
}
