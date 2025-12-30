{config, ...}: {
	imports = [
		(if config.machineType == "desktop" then ./profiles/desktop.nix else ./profiles/laptop_perso.nix)
	]
}
   
