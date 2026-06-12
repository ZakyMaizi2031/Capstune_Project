async function init() {
    const data = await apiRequest("/stats");
    document.getElementById('count-user').innerText = data.total_users;
    document.getElementById('count-scan').innerText = data.total_scans;
    document.getElementById('count-disease').innerText = data.total_diseases;
}
init();