# -*- mode: python ; coding: utf-8 -*-

import os

ROOT = os.path.abspath(SPECPATH)
ICON_PATH = os.path.join(ROOT, 'app_icon.ico')
EXE_ICON = ICON_PATH if os.path.exists(ICON_PATH) else None
DATA_FILES = [(ICON_PATH, '.')] if os.path.exists(ICON_PATH) else []


a = Analysis(
    [os.path.join(ROOT, 'app.py')],
    pathex=[ROOT],
    binaries=[],
    datas=DATA_FILES,
    hiddenimports=[],
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[],
    noarchive=False,
    optimize=0,
)
pyz = PYZ(a.pure)

exe = EXE(
    pyz,
    a.scripts,
    a.binaries,
    a.datas,
    [],
    name='ICDL-Ergebnisse',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    upx_exclude=[],
    runtime_tmpdir=None,
    console=False,
    icon=EXE_ICON,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
)
