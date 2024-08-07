{
  buildPythonPackage,
  fetchPypi,
  lib,

  # build dependencies
  cython,
  leptonica,
  pkg-config,
  tesseract4,

  # propagates
  pillow,

  # tests
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "tesserocr";
  version = "2.7.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-RcCTYwM30Bpqj5d6JGrW1zLrEfLgcrsibVmtPSR4HJk=";
  };

  # https://github.com/sirfz/tesserocr/issues/314
  postPatch = ''
    sed -i '/allheaders.h/a\    pass\n\ncdef extern from "leptonica/pix_internal.h" nogil:' tesseract.pxd
  '';

  nativeBuildInputs = [
    cython
    pkg-config
  ];

  buildInputs = [
    leptonica
    tesseract4
  ];

  propagatedBuildInputs = [ pillow ];

  pythonImportsCheck = [ "tesserocr" ];

  nativeCheckInputs = [ unittestCheckHook ];

  meta = with lib; {
    changelog = "https://github.com/sirfz/tesserocr/releases/tag/v${version}";
    description = "Simple, Pillow-friendly, wrapper around the tesseract-ocr API for Optical Character Recognition (OCR)";
    homepage = "https://github.com/sirfz/tesserocr";
    license = licenses.mit;
    maintainers = with maintainers; [ mtrsk ];
    platforms = platforms.linux;
  };
}
