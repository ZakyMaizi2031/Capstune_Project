async function load() {
    const data = await apiRequest("/encyclopedia/");
    const body = document.getElementById('table-body');
    body.innerHTML = data.map(item => `
        <tr>
            <td>${item.nama_penyakit}</td>
            <td>${item.penyebab}</td>
            <td><button onclick="hapus(${item.id_penyakit})" class="btn btn-danger btn-sm">Hapus</button></td>
        </tr>
    `).join('');
}

async function save() {
    const body = {
        nama_penyakit: document.getElementById('in-nama').value,
        gejala_visual: document.getElementById('in-gejala').value,
        penyebab: document.getElementById('in-penyebab').value,
        langkah_penanganan: document.getElementById('in-langkah').value,
        nama_obat: document.getElementById('in-obat').value
    };
    await apiRequest("/encyclopedia/", "POST", body);
    location.reload();
}

async function hapus(id) {
    if(confirm("Hapus penyakit ini?")) {
        await apiRequest(`/encyclopedia/${id}`, "DELETE");
        load();
    }
}
load();