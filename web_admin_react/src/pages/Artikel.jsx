import React, { useEffect, useState } from 'react';
import axios from 'axios';
import { Plus, Edit2, Trash2, ExternalLink, X, Upload } from 'lucide-react';

const Artikel = () => {
  const [articles, setArticles] = useState([]);
  const [loading, setLoading] = useState(true);

  const [isModalOpen, setIsModalOpen] = useState(false);
  const [formData, setFormData] = useState({
    id_artikel: null,
    judul: '',
    deskripsi: '',
    file_foto: null,
    preview_foto: ''
  });

  useEffect(() => {
    fetchArticles();
  }, []);

  const fetchArticles = async () => {
    try {
      setLoading(true);
      const response = await axios.get('http://localhost:8000/api/artikel/');
      setArticles(response.data);
    } catch (error) {
      console.error("Error fetching articles:", error);
    } finally {
      setLoading(false);
    }
  };

  const handleOpenModal = (article = null) => {
    if (article) {
      setFormData({
        id_artikel: article.id_artikel,
        judul: article.judul || '',
        deskripsi: article.deskripsi || '',
        file_foto: null,
        preview_foto: `http://localhost:8000/${article.foto_referensi}`
      });
    } else {
      setFormData({
        id_artikel: null,
        judul: '',
        deskripsi: '',
        file_foto: null,
        preview_foto: ''
      });
    }
    setIsModalOpen(true);
  };

  const handleCloseModal = () => {
    setIsModalOpen(false);
  };

  const handleFileChange = (e) => {
    const file = e.target.files[0];
    if (file) {
      setFormData({
        ...formData,
        file_foto: file,
        preview_foto: URL.createObjectURL(file)
      });
    }
  };

  const handleSave = async (e) => {
    e.preventDefault();
    try {
      const data = new FormData();
      data.append('judul', formData.judul);
      data.append('deskripsi', formData.deskripsi);
      if (formData.file_foto) {
        data.append('file_foto', formData.file_foto);
      }

      if (formData.id_artikel) {
        await axios.put(`http://localhost:8000/api/artikel/${formData.id_artikel}`, data, {
          headers: { 'Content-Type': 'multipart/form-data' }
        });
        alert('Artikel berhasil diperbarui!');
      } else {
        await axios.post('http://localhost:8000/api/artikel/', data, {
          headers: { 'Content-Type': 'multipart/form-data' }
        });
        alert('Artikel berhasil ditambahkan!');
      }
      setIsModalOpen(false);
      fetchArticles();
    } catch (err) {
      console.error(err);
      alert('Terjadi kesalahan saat menyimpan artikel.');
    }
  };

  const handleDelete = async (id) => {
    if (window.confirm('Apakah Anda yakin ingin menghapus artikel ini?')) {
      try {
        await axios.delete(`http://localhost:8000/api/artikel/${id}`);
        fetchArticles();
        alert('Artikel berhasil dihapus.');
      } catch (err) {
        console.error(err);
        alert('Gagal menghapus artikel.');
      }
    }
  };

  return (
    <div>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '1.5rem' }}>
        <h2 style={{ fontWeight: 800 }}>Daftar Artikel Edukasi</h2>
        <button className="btn btn-primary" onClick={() => handleOpenModal()}>
          <Plus size={18} /> Tambah Artikel
        </button>
      </div>

      <div className="card">
        {loading ? (
          <div>Loading data...</div>
        ) : (
          <div className="table-container">
            <table className="table">
              <thead>
                <tr>
                  <th style={{ width: '80px' }}>Foto</th>
                  <th>Judul Artikel</th>
                  <th style={{ width: '40%' }}>Deskripsi</th>
                  <th style={{ textAlign: 'right' }}>Aksi</th>
                </tr>
              </thead>
              <tbody>
                {articles.length > 0 ? (
                  articles.map((article) => (
                    <tr key={article.id_artikel}>
                      <td>
                        <img 
                          src={`http://localhost:8000/${article.foto_referensi}`} 
                          alt={article.judul}
                          style={{ width: '50px', height: '50px', objectFit: 'cover', borderRadius: '8px' }}
                          onError={(e) => { e.target.src = 'https://via.placeholder.com/50?text=No+Img'; }}
                        />
                      </td>
                      <td style={{ fontWeight: 600 }}>{article.judul}</td>
                      <td>
                        <p style={{ 
                          display: '-webkit-box', 
                          WebkitLineClamp: 2, 
                          WebkitBoxOrient: 'vertical', 
                          overflow: 'hidden',
                          margin: 0,
                          color: 'var(--text-muted)'
                        }}>
                          {article.deskripsi}
                        </p>
                      </td>
                      <td style={{ textAlign: 'right' }}>
                        <div style={{ display: 'flex', gap: '0.5rem', justifyContent: 'flex-end' }}>
                          <button 
                            style={{ color: 'var(--primary)', padding: '0.5rem' }} 
                            title="Edit"
                            onClick={() => handleOpenModal(article)}
                          >
                            <Edit2 size={18} />
                          </button>
                          <button 
                            style={{ color: 'var(--danger)', padding: '0.5rem' }} 
                            title="Hapus"
                            onClick={() => handleDelete(article.id_artikel)}
                          >
                            <Trash2 size={18} />
                          </button>
                        </div>
                      </td>
                    </tr>
                  ))
                ) : (
                  <tr>
                    <td colSpan="4" style={{ textAlign: 'center', padding: '2rem' }}>Belum ada artikel.</td>
                  </tr>
                )}
              </tbody>
            </table>
          </div>
        )}
      </div>

      {isModalOpen && (
        <div style={modalOverlayStyle}>
          <div style={modalContentStyle} className="animate-fade-in">
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '1.5rem' }}>
              <h3 style={{ fontWeight: 800 }}>{formData.id_artikel ? 'Edit Artikel' : 'Tambah Artikel'}</h3>
              <button onClick={handleCloseModal} style={{ color: 'var(--text-muted)' }}><X size={24} /></button>
            </div>

            <form onSubmit={handleSave}>
              <div className="form-group">
                <label className="form-label">Foto Thumbnail</label>
                <div style={{ display: 'flex', alignItems: 'center', gap: '1rem' }}>
                  {formData.preview_foto ? (
                    <img src={formData.preview_foto} alt="Preview" style={{ width: '80px', height: '80px', objectFit: 'cover', borderRadius: '8px' }} />
                  ) : (
                    <div style={{ width: '80px', height: '80px', backgroundColor: 'var(--surface-hover)', borderRadius: '8px', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                      <Upload size={24} color="var(--text-muted)" />
                    </div>
                  )}
                  <input type="file" accept="image/*" onChange={handleFileChange} className="form-control" />
                </div>
              </div>

              <div className="form-group">
                <label className="form-label">Judul Artikel</label>
                <input 
                  type="text" 
                  className="form-control" 
                  value={formData.judul} 
                  onChange={(e) => setFormData({...formData, judul: e.target.value})} 
                  required 
                />
              </div>

              <div className="form-group">
                <label className="form-label">Isi/Deskripsi Artikel</label>
                <textarea 
                  className="form-control" 
                  rows="6"
                  value={formData.deskripsi} 
                  onChange={(e) => setFormData({...formData, deskripsi: e.target.value})} 
                  required 
                ></textarea>
              </div>

              <div style={{ display: 'flex', gap: '1rem', justifyContent: 'flex-end', marginTop: '2rem' }}>
                <button type="button" onClick={handleCloseModal} className="btn" style={{ backgroundColor: 'var(--surface-hover)', color: 'var(--text-main)' }}>
                  Batal
                </button>
                <button type="submit" className="btn btn-primary">
                  Simpan Artikel
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
};

const modalOverlayStyle = {
  position: 'fixed',
  top: 0, left: 0, right: 0, bottom: 0,
  backgroundColor: 'rgba(0,0,0,0.5)',
  display: 'flex',
  alignItems: 'center',
  justifyContent: 'center',
  zIndex: 1000,
  padding: '1rem'
};

const modalContentStyle = {
  backgroundColor: 'white',
  padding: '2rem',
  borderRadius: '16px',
  width: '100%',
  maxWidth: '600px',
  maxHeight: '90vh',
  overflowY: 'auto',
  boxShadow: '0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04)'
};

export default Artikel;
