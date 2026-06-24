import React, { useEffect, useState } from 'react';
import axios from 'axios';
import { Plus, Edit2, Trash2, X } from 'lucide-react';

const Encyclopedia = () => {
  const [diseases, setDiseases] = useState([]);
  const [loading, setLoading] = useState(true);
  
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [formData, setFormData] = useState({
    id_penyakit: null,
    nama_penyakit: '',
    gejala_visual: '',
    penyebab: '',
    langkah_penanganan: '',
    nama_obat: ''
  });

  useEffect(() => {
    fetchDiseases();
  }, []);

  const fetchDiseases = async () => {
    try {
      setLoading(true);
      const response = await axios.get('http://localhost:8000/api/admin/encyclopedia');
      setDiseases(response.data);
    } catch (error) {
      console.error("Error fetching encyclopedia:", error);
    } finally {
      setLoading(false);
    }
  };

  const handleOpenModal = (disease = null) => {
    if (disease) {
      setFormData({
        id_penyakit: disease.id_penyakit,
        nama_penyakit: disease.nama_penyakit || '',
        gejala_visual: disease.gejala_visual || '',
        penyebab: disease.penyebab || '',
        langkah_penanganan: disease.rekomendasi?.langkah_penanganan || '',
        nama_obat: disease.rekomendasi?.nama_obat || ''
      });
    } else {
      setFormData({
        id_penyakit: null,
        nama_penyakit: '',
        gejala_visual: '',
        penyebab: '',
        langkah_penanganan: '',
        nama_obat: ''
      });
    }
    setIsModalOpen(true);
  };

  const handleCloseModal = () => {
    setIsModalOpen(false);
  };

  const handleSave = async (e) => {
    e.preventDefault();
    try {
      if (formData.id_penyakit) {
        await axios.put(`http://localhost:8000/api/admin/encyclopedia/${formData.id_penyakit}`, formData);
        alert('Data berhasil diperbarui!');
      } else {
        await axios.post('http://localhost:8000/api/admin/encyclopedia', formData);
        alert('Data berhasil ditambahkan!');
      }
      setIsModalOpen(false);
      fetchDiseases();
    } catch (err) {
      console.error(err);
      alert('Terjadi kesalahan saat menyimpan data.');
    }
  };

  const handleDelete = async (id) => {
    if (window.confirm('Apakah Anda yakin ingin menghapus data penyakit ini?')) {
      try {
        await axios.delete(`http://localhost:8000/api/admin/encyclopedia/${id}`);
        fetchDiseases();
        alert('Data berhasil dihapus.');
      } catch (err) {
        console.error(err);
        alert('Gagal menghapus data.');
      }
    }
  };

  return (
    <div>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '1.5rem' }}>
        <h2 style={{ fontWeight: 800 }}>Katalog Penyakit</h2>
        <button className="btn btn-primary" onClick={() => handleOpenModal()}>
          <Plus size={18} /> Tambah Penyakit
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
                  <th>No</th>
                  <th>Nama Penyakit</th>
                  <th>Penyebab</th>
                  <th style={{ width: '30%' }}>Gejala Visual</th>
                  <th style={{ textAlign: 'right' }}>Aksi</th>
                </tr>
              </thead>
              <tbody>
                {diseases.length > 0 ? (
                  diseases.map((disease, index) => (
                    <tr key={disease.id_penyakit}>
                      <td>{index + 1}</td>
                      <td style={{ fontWeight: 600 }}>{disease.nama_penyakit}</td>
                      <td>{disease.penyebab}</td>
                      <td>
                        <p style={{ 
                          display: '-webkit-box', 
                          WebkitLineClamp: 2, 
                          WebkitBoxOrient: 'vertical', 
                          overflow: 'hidden',
                          margin: 0
                        }}>
                          {disease.gejala_visual}
                        </p>
                      </td>
                      <td style={{ textAlign: 'right' }}>
                        <div style={{ display: 'flex', gap: '0.5rem', justifyContent: 'flex-end' }}>
                          <button 
                            style={{ color: 'var(--primary)', padding: '0.5rem' }}
                            onClick={() => handleOpenModal(disease)}
                          >
                            <Edit2 size={18} />
                          </button>
                          <button 
                            style={{ color: 'var(--danger)', padding: '0.5rem' }}
                            onClick={() => handleDelete(disease.id_penyakit)}
                          >
                            <Trash2 size={18} />
                          </button>
                        </div>
                      </td>
                    </tr>
                  ))
                ) : (
                  <tr>
                    <td colSpan="5" style={{ textAlign: 'center', padding: '2rem' }}>Tidak ada data penyakit ditemukan.</td>
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
              <h3 style={{ fontWeight: 800 }}>{formData.id_penyakit ? 'Edit Penyakit' : 'Tambah Penyakit'}</h3>
              <button onClick={handleCloseModal} style={{ color: 'var(--text-muted)' }}><X size={24} /></button>
            </div>

            <form onSubmit={handleSave}>
              <div className="form-group">
                <label className="form-label">Nama Penyakit</label>
                <input 
                  type="text" 
                  className="form-control" 
                  value={formData.nama_penyakit} 
                  onChange={(e) => setFormData({...formData, nama_penyakit: e.target.value})} 
                  required 
                />
              </div>

              <div className="form-group">
                <label className="form-label">Penyebab Utama</label>
                <input 
                  type="text" 
                  className="form-control" 
                  value={formData.penyebab} 
                  onChange={(e) => setFormData({...formData, penyebab: e.target.value})} 
                  required 
                />
              </div>

              <div className="form-group">
                <label className="form-label">Gejala Visual</label>
                <textarea 
                  className="form-control" 
                  rows="3"
                  value={formData.gejala_visual} 
                  onChange={(e) => setFormData({...formData, gejala_visual: e.target.value})} 
                  required 
                ></textarea>
              </div>

              <div className="form-group">
                <label className="form-label">Langkah Penanganan</label>
                <textarea 
                  className="form-control" 
                  rows="3"
                  value={formData.langkah_penanganan} 
                  onChange={(e) => setFormData({...formData, langkah_penanganan: e.target.value})} 
                  required 
                ></textarea>
              </div>

              <div className="form-group">
                <label className="form-label">Rekomendasi Obat (Opsional)</label>
                <input 
                  type="text" 
                  className="form-control" 
                  value={formData.nama_obat} 
                  onChange={(e) => setFormData({...formData, nama_obat: e.target.value})} 
                />
              </div>

              <div style={{ display: 'flex', gap: '1rem', justifyContent: 'flex-end', marginTop: '2rem' }}>
                <button type="button" onClick={handleCloseModal} className="btn" style={{ backgroundColor: 'var(--surface-hover)', color: 'var(--text-main)' }}>
                  Batal
                </button>
                <button type="submit" className="btn btn-primary">
                  Simpan Data
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

export default Encyclopedia;
