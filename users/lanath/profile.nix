# Personal profile for lanath.
# This is the single source of truth for all user-specific data.
# When forking, copy this file and replace all values.
{
  username = "lanath";
  homeDir = "/home/lanath";

  # Generate with: mkpasswd -m yescrypt
  hashedPassword = "$y$j9T$TFdhvKQ4clM.JxX1ScPkq1$tOxZv2DOIBWF/uhoyfCbzIkCYZuwa9BfEPNI4wmzqN3";

  # Filenames (relative to keys/) to authorize for SSH login
  sshKeyFiles = [ "lanath.pub" "id_ed25519.pub" ];

  git = {
    name = "lanath";
    personalEmail = "valentin@viviersoft.com";
    # GPG key fingerprint for commit signing
    gpgKey = "B3319E23B4F37099073FD764AC81A86C4854A64B";
    signByDefault = true;
    # Work directory relative to homeDir — triggers separate git identity
    workDir = "Work/stamus";
    workEmail = "vvivier@stamus-networks.com";
  };
}
