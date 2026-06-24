import React from 'react';
import { NavLink, Outlet } from 'react-router-dom';
import { LayoutDashboard, Users, BookOpen, FileText } from 'lucide-react';

const DashboardLayout = () => {
  return (
    <div className="app-container">
      {/* Sidebar */}
      <aside className="sidebar">
        <div className="sidebar-header">
          <img src="/logo.jpeg" alt="Logo" className="sidebar-logo" />
          <h2 className="sidebar-title">ChiliCare</h2>
        </div>
        
        <nav className="sidebar-nav">
          <NavLink to="/" className={({isActive}) => isActive ? "nav-item active" : "nav-item"}>
            <LayoutDashboard size={20} />
            <span>Dashboard</span>
          </NavLink>
          <NavLink to="/users" className={({isActive}) => isActive ? "nav-item active" : "nav-item"}>
            <Users size={20} />
            <span>Petani</span>
          </NavLink>
          <NavLink to="/encyclopedia" className={({isActive}) => isActive ? "nav-item active" : "nav-item"}>
            <BookOpen size={20} />
            <span>Penyakit</span>
          </NavLink>
          <NavLink to="/artikel" className={({isActive}) => isActive ? "nav-item active" : "nav-item"}>
            <FileText size={20} />
            <span>Artikel</span>
          </NavLink>
        </nav>
      </aside>

      {/* Main Content */}
      <main className="main-content">
        <header className="topbar">
          <h1 className="topbar-title">Admin Dashboard</h1>
          <div className="topbar-profile">
            <div className="profile-avatar">A</div>
            <span>Admin ChiliCare</span>
          </div>
        </header>

        <div className="content-area animate-fade-in">
          <Outlet />
        </div>
      </main>

      {/* Inline styles for components not in global.css to keep it organized */}
      <style>{`
        .sidebar {
          width: 260px;
          background-color: var(--sidebar-bg);
          color: var(--sidebar-text);
          display: flex;
          flex-direction: column;
        }
        .sidebar-header {
          height: 70px;
          display: flex;
          align-items: center;
          padding: 0 1.5rem;
          gap: 1rem;
          border-bottom: 1px solid rgba(255,255,255,0.05);
        }
        .sidebar-logo {
          width: 32px;
          height: 32px;
          border-radius: 8px;
        }
        .sidebar-title {
          color: white;
          font-size: 1.25rem;
          font-weight: 800;
        }
        .sidebar-nav {
          padding: 1.5rem 1rem;
          display: flex;
          flex-direction: column;
          gap: 0.5rem;
        }
        .nav-item {
          display: flex;
          align-items: center;
          gap: 1rem;
          padding: 0.875rem 1rem;
          border-radius: var(--radius-md);
          font-weight: 500;
          transition: var(--transition);
        }
        .nav-item:hover {
          background-color: rgba(255,255,255,0.05);
          color: white;
        }
        .nav-item.active {
          background-color: var(--sidebar-active-bg);
          color: var(--sidebar-active-text);
        }
        .topbar-profile {
          display: flex;
          align-items: center;
          gap: 1rem;
          font-weight: 600;
        }
        .profile-avatar {
          width: 36px;
          height: 36px;
          border-radius: 50%;
          background-color: var(--primary);
          color: white;
          display: flex;
          align-items: center;
          justify-content: center;
        }
      `}</style>
    </div>
  );
};

export default DashboardLayout;
