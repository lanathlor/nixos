self: super: {
  linux-firmware = super.linux-firmware.overrideAttrs (oldAttrs: {
    version = "20250410";
    src = super.fetchzip {
      url = "https://cdn.kernel.org/pub/linux/kernel/firmware/linux-firmware-20250410.tar.xz";
      hash = "sha256-aQdEl9+7zbNqWSII9hjRuPePvSfWVql5u5TIrGsa+Ao=";
    };
  });
}
