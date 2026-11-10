# ISRI Website (Jekyll)

Modernized version of the supplied AIST Intelligent Systems Research Institute website. The original Japanese and English content, research group information, images, and AIST logos are retained.

## Publish
1. Push all files to `main` in `n-ando/isri.github.io`.
2. In Settings → Pages select **Deploy from a branch**, `main`, `/ (root)`.
3. The site should appear at `https://n-ando.github.io/isri.github.io/`.

## Preview locally
```sh
bundle install
bundle exec jekyll serve
```

If publishing under another repository/domain, adjust `url` and `baseurl` in `_config.yml`.

## Notes
The source is an archive dated 2026-11-02. Check links to external websites and dated notices before publication. Some pages from the old website refer to external AIST services.
