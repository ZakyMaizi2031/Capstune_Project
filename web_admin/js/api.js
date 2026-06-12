const BASE_URL = "http://localhost:8000/api/admin";

// Fungsi helper untuk fetch agar kode di file lain lebih pendek
async function apiRequest(endpoint, method = "GET", body = null) {
    const options = {
        method,
        headers: { "Content-Type": "application/json" }
    };
    if (body) options.body = JSON.stringify(body);
    
    const response = await fetch(`${BASE_URL}${endpoint}`, options);
    return await response.json();
}