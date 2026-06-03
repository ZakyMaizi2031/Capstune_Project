import uuid
import aiofiles
import os
from ..config import UPLOAD_DIR

async def save_upload_file(upload_file, subdir="") -> str:
    """
    Menyimpan file upload ke disk, mengembalikan path relatif
    """
    ext = os.path.splitext(upload_file.filename)[1]
    unique_name = f"{uuid.uuid4().hex}{ext}"
    if subdir:
        save_dir = UPLOAD_DIR / subdir
        save_dir.mkdir(exist_ok=True)
        file_path = save_dir / unique_name
    else:
        file_path = UPLOAD_DIR / unique_name
    
    async with aiofiles.open(file_path, 'wb') as out_file:
        content = await upload_file.read()
        await out_file.write(content)
    
    # Kembalikan path relatif dari UPLOAD_DIR
    return str(file_path.relative_to(UPLOAD_DIR))