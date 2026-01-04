{config, ...} : {

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    powerManagement = {
			enable = true;
			# finegrained = true;
		};

#   prime = {
# offload = {
# 				enable = true;
# 				enableOffloadCmd = true; # enables nvidia-offload for bypassing
# 			};
# intelBusId = "PCI:00:02:0";
# 			nvidiaBusId = "PCI:1:0:0";
#
# 		};
  };
}
