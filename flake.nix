{
  description = "cir-ingredients BioBrick";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils";
    dev-shell.url = "github:biobricks-ai/dev-shell";
  };

  outputs = { self, nixpkgs, flake-utils, dev-shell }:
    {
      overlays.default = final: prev: {
        perlPackages = prev.perlPackages // {
          HashFold = final.perlPackages.buildPerlPackage {
            pname = "Hash-Fold";
            version = "1.0.0";
            src = final.fetchurl {
              url = "mirror://cpan/authors/id/C/CH/CHOCOLATE/Hash-Fold-v1.0.0.tar.gz";
              hash = "sha256-wb+KP8C8QHwdrfOkMmmYXxD98P/b68XzK9jhYageAMo=";
            };
            buildInputs = with final.perlPackages; [ TestFatal ];
            propagatedBuildInputs = with final.perlPackages; [ Moo SubExporter Throwable TypeTiny ];
            meta = {
              description = "Flatten and unflatten nested hashrefs";
              license = final.lib.licenses.artistic2;
            };
          };
          WebScraper = final.perlPackages.buildPerlModule {
            pname = "Web-Scraper";
            version = "0.38";
            src = final.fetchurl {
              url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/Web-Scraper-0.38.tar.gz";
              hash = "sha256-+VtuX41/7r4RbQW/WaK3zxpR7Z0wvKgBI0MOxFZ1Q78=";
            };
            buildInputs = with final.perlPackages; [ ModuleBuildTiny TestBase TestRequires ];
            propagatedBuildInputs = with final.perlPackages; [ HTMLParser HTMLSelectorXPath HTMLTagset HTMLTree HTMLTreeBuilderXPath LWP UNIVERSALrequire URI XMLXPathEngine YAML ];
            meta = {
              homepage = "https://github.com/miyagawa/web-scraper";
              description = "Web Scraping Toolkit using HTML and CSS Selectors or XPath expressions";
              license = with final.lib.licenses; [ artistic1 gpl1Plus ];
            };
          };
          LWP = final.perlPackages.buildPerlPackage {
            pname = "libwww-perl";
            version = "6.76";
            src = final.fetchurl {
              url = "mirror://cpan/authors/id/O/OA/OALDERS/libwww-perl-6.76.tar.gz";
              hash = "sha256-dcLlfWEC7qVA82EbVv2GJopZsCLdAOplYqw2QS/N+OE=";
            };
            buildInputs = with final.perlPackages; [ HTTPCookieJar HTTPDaemon TestFatal TestNeeds TestRequiresInternet ];
            propagatedBuildInputs = with final.perlPackages; [ EncodeLocale FileListing HTMLParser HTTPCookies HTTPDate HTTPMessage HTTPNegotiate LWPMediaTypes NetHTTP TryTiny URI WWWRobotRules ];
            meta = {
              homepage = "https://github.com/libwww-perl/libwww-perl";
              description = "The World-Wide Web library for Perl";
              license = with final.lib.licenses; [ artistic1 gpl1Plus ];
            };
          };
          PathTiny = final.perlPackages.buildPerlPackage {
            pname = "Path-Tiny";
            version = "0.144";
            src = final.fetchurl {
              url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/Path-Tiny-0.144.tar.gz";
              hash = "sha256-9uoJTs6EXJUqAsJ4kzJXk1TejUEKcH+bcEW9JBIGSH0=";
            };
            meta = {
              homepage = "https://github.com/dagolden/Path-Tiny";
              description = "File path utility";
              license = final.lib.licenses.asl20;
            };
          };
        };
      };
    } //
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs {
        inherit system;
        overlays = [ self.overlays.default ];
      }; in {
        devShells.default = dev-shell.devShells.${system}.default.overrideAttrs
          (oldAttrs: {
            buildInputs = oldAttrs.buildInputs ++ [
              pkgs.perlPackages.DataPrinter
              pkgs.perlPackages.HashFold
              pkgs.perlPackages.WWWMechanize
              pkgs.perlPackages.WebScraper
              pkgs.perlPackages.LWPProtocolhttps
              pkgs.perlPackages.Moo
              pkgs.perlPackages.TextCSV_XS
              pkgs.perlPackages.PathTiny
              pkgs.perlPackages.ListUtilsBy
            ];
          });
      });
}
