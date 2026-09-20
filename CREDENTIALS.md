# BNG Optica — Test Credentials & Demo Accounts

This file contains the demo accounts and stores created for testing the **BNG Optica** application with the live Supabase backend.

---

## 1. Demo Store Accounts

All accounts are pre-verified, authenticated, marked as `is_store_owner = true`, and linked to their approved optical store with uploaded showcase images.

| Store / City | Email | Password | Owner Name | Phone Number | Location |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Alger** | `optica.alger@demo.com` | `Password123!` | Karim Optique Alger | `+213 550 12 34 56` | Rue Didouche Mourad, Alger Centre |
| **Oran** | `optica.oran@demo.com` | `Password123!` | Amine Optique Oran | `+213 551 98 76 54` | Boulevard de l'ALN (Front de Mer), Oran |
| **Constantine** | `optica.constantine@demo.com` | `Password123!` | Sofiane Optique Cirta | `+213 552 45 67 89` | Avenue Aouati Mostefa, Constantine |

---

## 2. Store Details & Image Assets

Each store has real optical shop images hosted in the public Supabase Storage bucket (`stores` and `profiles`):

### 1. Optique Didouche Alger
- **Store Name**: Optique Didouche Alger
- **Store ID**: `c4240ebd-0270-4df3-b5f6-0995222b82ef`
- **Owner ID**: `d8363b4e-7340-4870-91b4-2136745085c1`
- **Description**: Spécialiste en verres progressifs, montures de vue, solaires et lentilles de contact.
- **Location**: Rue Didouche Mourad, Alger Centre
- **Owner Avatar**: `https://gajnctcaqqtlplmnevqz.supabase.co/storage/v1/object/public/profiles/owner_alger.jpg`
- **Showcase Pictures**:
  1. `https://gajnctcaqqtlplmnevqz.supabase.co/storage/v1/object/public/stores/alger_store_1.jpg`
  2. `https://gajnctcaqqtlplmnevqz.supabase.co/storage/v1/object/public/stores/alger_store_2.jpg`

---

### 2. Optique El Bahia Oran
- **Store Name**: Optique El Bahia Oran
- **Store ID**: `827e2470-623b-4831-aeac-052c44362d83`
- **Owner ID**: `d184cf76-f978-4b38-949a-84f532c10ff9`
- **Description**: Examen de vue précis, grand choix de montures tendance et verres haute précision.
- **Location**: Boulevard de l'ALN (Front de Mer), Oran
- **Owner Avatar**: `https://gajnctcaqqtlplmnevqz.supabase.co/storage/v1/object/public/profiles/owner_oran.jpg`
- **Showcase Pictures**:
  1. `https://gajnctcaqqtlplmnevqz.supabase.co/storage/v1/object/public/stores/oran_store_1.jpg`
  2. `https://gajnctcaqqtlplmnevqz.supabase.co/storage/v1/object/public/stores/oran_store_2.jpg`

---

### 3. Optique Cirta Constantine
- **Store Name**: Optique Cirta Constantine
- **Store ID**: `0874193f-03b3-4efe-9a45-2ef8e10a159a`
- **Owner ID**: `26e8da84-bbe1-43ef-bc8f-819e35169357`
- **Description**: Atelier de montage numérique verres optiques, service rapide et garanties.
- **Location**: Avenue Aouati Mostefa, Constantine
- **Owner Avatar**: `https://gajnctcaqqtlplmnevqz.supabase.co/storage/v1/object/public/profiles/owner_constantine.jpg`
- **Showcase Pictures**:
  1. `https://gajnctcaqqtlplmnevqz.supabase.co/storage/v1/object/public/stores/constantine_store_1.jpg`
  2. `https://gajnctcaqqtlplmnevqz.supabase.co/storage/v1/object/public/stores/constantine_store_2.jpg`

---

## 3. Supabase Project Reference

| Key | Value |
| :--- | :--- |
| **Project Reference** | `gajnctcaqqtlplmnevqz` |
| **Project URL** | `https://gajnctcaqqtlplmnevqz.supabase.co` |
| **Auth Mode** | Auto-confirm enabled (`mailer_autoconfirm: true`), no email rate limits |
| **Public Storage Buckets** | `profiles`, `stores` |
