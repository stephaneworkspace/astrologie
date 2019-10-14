cd python
rm -rf astro_py
git clone https://github.com/stephaneworkspace/astro_py.git
cd astro_py
mv exemple.py run.py
cd flatlib
python3 setup.py install
cd ..
python3 setup.py install
rm -rf astro_py_texte
# Repository private for text on french, this library is not required, text comming from book, not my texts
git clone https://github.com/stephaneworkspace/astro_py_text.git
cd astro_py_text
python3 setup.py install