cd python
rm -rf astropyfr
git clone https://github.com/stephaneworkspace/astro_py.git astropyfr
cd astropyfr
mv exemple.py run.py
python3 setup.py install
rm -rf astro_py_texte
# Repository private for text on french, this library is not required, text comming from book, not my texts
git clone https://github.com/stephaneworkspace/astro_py_text.git assets
cd assets
cd svg
rm -rf ../../../../assets/svg/astro_py_text
mv astro_py_text ../../../../assets/svg
cd ..
cd png
rm -rf ../../../../assets/png/astro_py_text
mv astro_py_text ../../../../assets/png/astro_py_text