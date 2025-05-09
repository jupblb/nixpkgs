{
  curl,
  fetchFromGitHub,
  fetchpatch,
  lib,
  lz4,
  postgresql,
  postgresqlBuildExtension,
  stdenv,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "citus";
  version = "13.0.3";

  src = fetchFromGitHub {
    owner = "citusdata";
    repo = "citus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tQ2YkMUeziz+dhfXtfuK0x8PWH3vfoJiVbE+YvQ/Gzc=";
  };

  patches = [
    # Even though this commit is on main since Sep 2023, it hasn't made its way to the release-13.0 branch, yet.
    # https://github.com/citusdata/citus/pull/7221
    # Fixes build for PG 16 + 17 on darwin
    (fetchpatch {
      url = "https://github.com/citusdata/citus/commit/0f28a69f12418d211ffba5f7ddd222fd0c47daeb.patch";
      hash = "sha256-8JAM+PUswzbdlAZUpRApgO0eBsMbUHFdFGsdATsG88I=";
    })
  ];

  buildInputs = [
    curl
    lz4
  ];

  meta = {
    # "Our soft policy for Postgres version compatibility is to support Citus'
    # latest release with Postgres' 3 latest releases."
    # https://www.citusdata.com/updates/v12-0/#deprecated_features
    broken = lib.versionOlder postgresql.version "15";
    description = "Distributed PostgreSQL as an extension";
    homepage = "https://www.citusdata.com/";
    changelog = "https://github.com/citusdata/citus/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = [ ];
    inherit (postgresql.meta) platforms;
  };
})
