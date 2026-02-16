{pkgs, ...}: {
  home.packages = with pkgs; [
    (symlinkJoin {
      name = "proton-authenticator-wrapped";
      paths = [proton-authenticator];
      nativeBuildInputs = [makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/proton-authenticator \
          --set WEBKIT_DISABLE_COMPOSITING_MODE 1 \
          --set WEBKIT_DISABLE_DMABUF_RENDERER 1 \
          --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libsecret ]}"
      '';
    })
    libsecret
  ];
}
