import React, { useEffect, useState } from 'react';
import axios from 'axios';
import { Users, AlertTriangle, Scan } from 'lucide-react';

const Dashboard = () => {
  const [stats, setStats] = useState({
    total_users: 0,
    total_diseases: 0,
    total_scans: 0
  });
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchStats = async () => {
      try {
        const response = await axios.get('http://localhost:8000/api/admin/stats');
        setStats(response.data);
      } catch (error) {
        console.error("Error fetching stats:", error);
      } finally {
        setLoading(false);
      }
    };
    fetchStats();
  }, []);

  if (loading) {
    return <div>Loading...</div>;
  }

  return (
    <div>
      <h2 style={{ marginBottom: '1.5rem', fontWeight: 800 }}>Ringkasan Sistem</h2>
      
      <div className="stats-grid">
        {/* Card 1 */}
        <div className="card stat-card">
          <div className="stat-icon" style={{ backgroundColor: 'var(--primary-light)', color: 'var(--primary-dark)' }}>
            <Users size={28} />
          </div>
          <div className="stat-info">
            <h3>Total Petani</h3>
            <p className="stat-value">{stats.total_users}</p>
          </div>
        </div>

        {/* Card 2 */}
        <div className="card stat-card">
          <div className="stat-icon" style={{ backgroundColor: 'var(--warning-light)', color: 'var(--warning)' }}>
            <AlertTriangle size={28} />
          </div>
          <div className="stat-info">
            <h3>Total Penyakit</h3>
            <p className="stat-value">{stats.total_diseases}</p>
          </div>
        </div>

        {/* Card 3 */}
        <div className="card stat-card">
          <div className="stat-icon" style={{ backgroundColor: '#E0E7FF', color: '#4F46E5' }}>
            <Scan size={28} />
          </div>
          <div className="stat-info">
            <h3>Total Scan Dilakukan</h3>
            <p className="stat-value">{stats.total_scans}</p>
          </div>
        </div>
      </div>

      <style>{`
        .stats-grid {
          display: grid;
          grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
          gap: 1.5rem;
        }
        .stat-card {
          display: flex;
          align-items: center;
          gap: 1.5rem;
        }
        .stat-icon {
          width: 60px;
          height: 60px;
          border-radius: 16px;
          display: flex;
          align-items: center;
          justify-content: center;
        }
        .stat-info h3 {
          font-size: 0.875rem;
          color: var(--text-muted);
          font-weight: 600;
          text-transform: uppercase;
          letter-spacing: 0.05em;
          margin-bottom: 0.25rem;
        }
        .stat-value {
          font-size: 2rem;
          font-weight: 800;
          color: var(--text-main);
        }
      `}</style>
    </div>
  );
};

export default Dashboard;
