DROP DATABASE webshop;
CREATE DATABASE webshop;
USE webshop; 

CREATE TABLE kategorije_proizvoda (
    id INT AUTO_INCREMENT PRIMARY KEY,
    naziv VARCHAR(255) NOT NULL UNIQUE,
    opis TEXT  NOT NULL
);

CREATE TABLE proizvodi (
    id INT AUTO_INCREMENT PRIMARY KEY,
    naziv VARCHAR(255) NOT NULL,
    opis TEXT NOT NULL,
    cijena DECIMAL(10, 2) NOT NULL,
    kategorija_id INT NOT NULL,
    kolicina_na_skladistu INT NOT NULL,
    slika VARCHAR(255),
    specifikacije TEXT,
    datum_kreiranja TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_cijena_proizvodi CHECK (cijena > 0),
    CONSTRAINT chk_kolicina_proizvodi CHECK (kolicina_na_skladistu >= 0),
    CONSTRAINT fk_kategorija_proizvoda_proizvodi FOREIGN KEY (kategorija_id) REFERENCES kategorije_proizvoda(id)
);

CREATE TABLE korisnici (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ime VARCHAR(255) NOT NULL,
    prezime VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    lozinka VARCHAR(255) NOT NULL,
    adresa TEXT,
    grad VARCHAR(255),
    telefon VARCHAR(20),
    tip_korisnika ENUM('kupac', 'admin') NOT NULL,
    datum_registracije DATE NOT NULL
);

CREATE TABLE nacini_isporuke (
    id INT AUTO_INCREMENT PRIMARY KEY,
    naziv VARCHAR(255) NOT NULL,
    opis TEXT,
    cijena DECIMAL(10, 2) NOT NULL,
    trajanje INT,
    CONSTRAINT chk_trajanje_nacin_isporuke CHECK (trajanje > -1)
);

CREATE TABLE kuponi (
    id INT AUTO_INCREMENT PRIMARY KEY,
    kod VARCHAR(50) UNIQUE NOT NULL,
    postotak_popusta DECIMAL(5, 2) NOT NULL,
    datum_pocetka DATE NOT NULL,
    datum_zavrsetka DATE NOT NULL,
    max_iskoristenja INT NOT NULL
);

CREATE TABLE narudzbe (
    id INT AUTO_INCREMENT PRIMARY KEY,
    korisnik_id INT NOT NULL,
    datum_narudzbe DATE NOT NULL,
    status_narudzbe ENUM('u obradi', 'poslano', 'dostavljeno') NOT NULL,
    ukupna_cijena DECIMAL(10, 2) NOT NULL,
    nacin_isporuke_id INT,
    kupon_id INT NULL,
    FOREIGN KEY (korisnik_id) REFERENCES korisnici(id),
    FOREIGN KEY (nacin_isporuke_id) REFERENCES nacini_isporuke(id),
    FOREIGN KEY (kupon_id) REFERENCES kuponi(id)
);

CREATE TABLE stavke_narudzbe (
    id INT AUTO_INCREMENT PRIMARY KEY,
    narudzba_id INT NOT NULL,
    proizvod_id INT NOT NULL,
    kolicina INT NOT NULL,
    FOREIGN KEY (narudzba_id) REFERENCES narudzbe(id),
    FOREIGN KEY (proizvod_id) REFERENCES proizvodi(id)
);

CREATE TABLE placanja (
    id INT AUTO_INCREMENT PRIMARY KEY,
    narudzba_id INT NOT NULL,
    nacin_placanja ENUM('kartica', 'pouzeće') NOT NULL,
    iznos DECIMAL(10, 2) NOT NULL,
    datum_placanja DATE NOT NULL,
    FOREIGN KEY (narudzba_id) REFERENCES narudzbe(id)
);

CREATE TABLE racuni (
    id INT AUTO_INCREMENT PRIMARY KEY,
    korisnik_id INT NOT NULL,
    narudzba_id INT NOT NULL,
    iznos DECIMAL(10, 2) NOT NULL,
    datum_izdavanja DATE NOT NULL,
    FOREIGN KEY (korisnik_id) REFERENCES korisnici(id),
    FOREIGN KEY (narudzba_id) REFERENCES narudzbe(id)
);

CREATE TABLE povrati_proizvoda (
    id INT AUTO_INCREMENT PRIMARY KEY,
    stavka_id INT NOT NULL,
    datum_povrata DATE NOT NULL,
    razlog TEXT NOT NULL,
    status_povrata ENUM('u obradi', 'odbijeno', 'odobreno') NOT NULL,
    FOREIGN KEY (stavka_id) REFERENCES stavke_narudzbe(id)
);

CREATE TABLE popusti (
    id INT AUTO_INCREMENT PRIMARY KEY,
    proizvod_id INT NOT NULL,
    postotak_popusta DECIMAL(5, 2) NOT NULL,
    datum_pocetka DATE NOT NULL,
    datum_zavrsetka DATE NOT NULL,
    CONSTRAINT chk_postotak_popusta_popusti CHECK (postotak_popusta BETWEEN 0 AND 100),
    CONSTRAINT chk_datum_pocetka_and_datum_zavrsetka_popusti CHECK (datum_pocetka <= datum_zavrsetka),
    CONSTRAINT fk_proizvod_popusti FOREIGN KEY (proizvod_id) REFERENCES proizvodi(id)
);

CREATE TABLE recenzije_proizvoda (
    id INT AUTO_INCREMENT PRIMARY KEY,
    proizvod_id INT NOT NULL,
    korisnik_id INT NOT NULL,
    ocjena INT NOT NULL,
    komentar TEXT,
    datum_recenzije TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_ocjena_recenzije_proizvoda CHECK (ocjena BETWEEN 1 AND 5),
    CONSTRAINT fk_proizvod_recenzija_recenzije_proizvoda FOREIGN KEY (proizvod_id) REFERENCES proizvodi(id),
    CONSTRAINT fk_korisnik_recenzija_recenzije_proizvoda FOREIGN KEY (korisnik_id) REFERENCES korisnici(id)
);

CREATE TABLE wishlist (
    id INT AUTO_INCREMENT PRIMARY KEY,
    korisnik_id INT NOT NULL,
    proizvod_id INT NOT NULL,
    FOREIGN KEY (korisnik_id) REFERENCES korisnici(id),
    FOREIGN KEY (proizvod_id) REFERENCES proizvodi(id)
);

CREATE TABLE pracenje_isporuka (
    id INT AUTO_INCREMENT PRIMARY KEY,
    narudzba_id INT NOT NULL,
    status_isporuke ENUM('u pripremi', 'poslano', 'dostavljeno') NOT NULL,
    datum_isporuke DATE,
    FOREIGN KEY (narudzba_id) REFERENCES narudzbe(id)
);


CREATE TABLE preporuceni_proizvodi (
    id INT AUTO_INCREMENT PRIMARY KEY,
    korisnik_id INT NOT NULL,
    proizvod_id INT NOT NULL,
    razlog_preporuke TEXT,
    FOREIGN KEY (korisnik_id) REFERENCES korisnici(id),
    FOREIGN KEY (proizvod_id) REFERENCES proizvodi(id)
);

CREATE TABLE podrska_za_korisnike (
    id INT AUTO_INCREMENT PRIMARY KEY,
    korisnik_id INT NOT NULL,
    tema VARCHAR(255) NOT NULL,
    poruka TEXT NOT NULL,
    status ENUM('otvoreno', 'riješeno') NOT NULL,
    datum_upita DATE NOT NULL,
    datum_odgovora DATE,
    FOREIGN KEY (korisnik_id) REFERENCES korisnici(id)
);

CREATE TABLE kosarica (
    id INT AUTO_INCREMENT PRIMARY KEY,
    korisnik_id INT NOT NULL,
    proizvod_id INT NOT NULL,
    kolicina INT NOT NULL,
    FOREIGN KEY (proizvod_id) REFERENCES proizvodi(id)
);

INSERT INTO kategorije_proizvoda (id, naziv, opis) VALUES
	(1,'Laptopi', 'Različiti modeli prijenosnih računala.'),
	(2,'Desktop računala', 'Računala za radne stanice i gaming.'),
	(3,'Monitori', 'Visokokvalitetni monitori za rad i zabavu.'),
	(4,'Tipkovnice', 'Mehaničke i membranske tipkovnice.'),
	(5,'Miševi', 'Optički i gaming miševi.'),
	(6,'Grafičke kartice', 'Grafičke kartice za gaming i profesionalnu upotrebu.'),
	(7,'Hard diskovi', 'HDD i SSD za pohranu podataka.'),
	(8,'RAM memorija', 'Različite vrste RAM memorije.'),
	(9,'Matične ploče', 'Matične ploče za razne konfiguracije.'),
	(10,'Napajanja', 'Kvalitetna napajanja za računala.'),
	(11,'Hladnjaci', 'Hladnjaci za procesore i kućišta.'),
	(12,'Kućišta', 'Različita kućišta za računala.'),
	(13,'Printeri', 'Printeri laserski, inkjet,...'),
	(14,'Softver', 'Razni softverski alati i aplikacije.'),
	(15,'Mrežna oprema', 'Routeri, switchevi i modemi.'),
	(16,'Igraće konzole', 'Konzole za video igre.'),
	(17,'Prijenosni diskovi', 'USB i eksterni diskovi.'),
	(18,'Pametni telefoni', 'Različiti modeli pametnih telefona.'),
	(19,'Tableti', 'Tableti raznih marki i specifikacija.'),
	(20,'Dronovi', 'Dronovi za zabavu i profesionalnu upotrebu.'),
	(21,'Kamere', 'Digitalne kamere i akcijske kamere.'),
	(22,'Audio oprema', 'Slušalice i zvučnici.'),
	(23,'Procesori', 'Procesori raznih snaga.'),
	(24,'Projektori', 'Razni projektori.'),
	(25,'Igraće opreme', 'Igraće stolice i oprema.'),
	(26,'Oprema za virtualnu stvarnost', 'VR naočale i dodaci.'),
	(27,'Kablovi i adapteri', 'Razni kablovi i adapteri.'),
	(28,'Računalne igre', 'Različite računalne igre.'),
	(29,'Pametni satovi', 'Razni pametni satovi i smart narukvice.'),
	(30,'3D pisači', 'Pisači za 3D printanje.');



INSERT INTO proizvodi (id, naziv, opis, cijena, kategorija_id, kolicina_na_skladistu, slika, specifikacije, datum_kreiranja) VALUES
	(1, 'HP Pavilion 15', 'Prijenosno računalo s Intel i5 procesorom.', 6999.99, 1, 50, 'hp_pavilion_15.jpg', 'Intel i5, 8GB RAM, 512GB SSD, 15.6" Full HD', '2023-01-01'),
	(2, 'Dell XPS 13', 'Prijenosno računalo s 4K ekranom.', 10999.99, 1, 30, 'dell_xps_13.jpg', 'Intel i7, 16GB RAM, 1TB SSD, 13.3" 4K UHD', '2023-01-02'),
	(3, 'Lenovo ThinkPad X1 Carbon', 'Lagano prijenosno računalo.', 12999.99, 1, 25, 'lenovo_thinkpad_x1_carbon.jpg', 'Intel i7, 16GB RAM, 512GB SSD, 14" UHD', '2023-01-03'),
	(4, 'ASUS ROG Zephyrus G14', 'Gaming prijenosno računalo.', 14999.99, 1, 20, 'asus_rog_zephyrus_g14.jpg', 'Ryzen 9, 32GB RAM, 1TB SSD, 14" QHD', '2023-01-04'),
	(5, 'Acer Swift 3', 'Prijenosno računalo za studente.', 5999.99, 1, 40, 'acer_swift_3.jpg', 'Intel i5, 8GB RAM, 256GB SSD, 14" Full HD', '2023-01-05'),
	(6, 'Microsoft Surface Laptop 4', 'Elegantan prijenosnik s dugim trajanjem baterije.', 10999.99, 1, 35, 'microsoft_surface_laptop_4.jpg', 'Intel i5, 8GB RAM, 512GB SSD, 13.5" PixelSense', '2023-01-06'),
	(7, 'Razer Blade 15', 'Gaming prijenosno računalo s vrhunskim performansama.', 19999.99, 1, 15, 'razer_blade_15.jpg', 'Intel i7, 16GB RAM, RTX 3070, 15.6" FHD', '2023-01-07'),
	(8, 'HP Spectre x360', 'Konvertibilno prijenosno računalo.', 13999.99, 1, 10, 'hp_spectre_x360.jpg', 'Intel i7, 16GB RAM, 1TB SSD, 13.3" 4K', '2023-01-08'),
	(9, 'Dell Inspiron 15', 'Prijenosno računalo za svakodnevnu upotrebu.', 4999.99, 1, 55, 'dell_inspiron_15.jpg', 'Intel i5, 8GB RAM, 1TB HDD, 15.6" HD', '2023-01-09'),
	(10, 'Lenovo IdeaPad 3', 'Prijenosno računalo s dobrim performansama.', 4499.99, 1, 60, 'lenovo_ideapad_3.jpg', 'AMD Ryzen 5, 8GB RAM, 512GB SSD, 15.6" FHD', '2023-01-10'),
	(11, 'ASUS VivoBook 15', 'Prijenosno računalo s modernim dizajnom.', 4999.99, 1, 65, 'asus_vivobook_15.jpg', 'Intel i5, 8GB RAM, 256GB SSD, 15.6" FHD', '2023-01-11'),
	(12, 'Acer Aspire 5', 'Prijenosno računalo za rad i zabavu.', 5499.99, 1, 70, 'acer_aspire_5.jpg', 'Intel i5, 12GB RAM, 512GB SSD, 15.6" FHD', '2023-01-12'),
	(13, 'HP Omen 15', 'Gaming prijenosno računalo.', 15999.99, 1, 75, 'hp_omen_15.jpg', 'Intel i7, 16 GB RAM, RTX 3060, 15.6" FHD', '2023-01-13'),
	(14, 'MSI Prestige 14', 'Prijenosno računalo za kreativne profesionalce.', 13999.99, 1, 80, 'msi_prestige_14.jpg', 'Intel i7, 16GB RAM, 1TB SSD, 14" 4K', '2023-01-14'),
	(15, 'Gigabyte Aero 15', 'Gaming i kreativno prijenosno računalo.', 17999.99, 1, 85, 'gigabyte_aero_15.jpg', 'Intel i7, 16GB RAM, RTX 3070, 15.6" 4K', '2023-01-15'),
	(16, 'Samsung Galaxy Book Pro', 'Lagano prijenosno računalo s AMOLED ekranom.', 10999.99, 1, 90, 'samsung_galaxy_book_pro.jpg', 'Intel i5, 8GB RAM, 512GB SSD, 13.3" AMOLED', '2023-01-16'),
	(17, 'Huawei MateBook 14', 'Prijenosno računalo s elegantnim dizajnom.', 9999.99, 1, 95, 'huawei_matebook_14.jpg', 'Intel i5, 16GB RAM, 512GB SSD, 14" FHD', '2023-01-17'),
	(18, 'Toshiba Dynabook Tecra A40', 'Prijenosno računalo za poslovne korisnike.', 8499.99, 1, 100, 'toshiba_dynabook_tecra_a40.jpg', 'Intel i5, 8GB RAM, 256GB SSD, 14" FHD', '2023-01-18'),
	(19, 'LG Gram 17', 'Lagano prijenosno računalo s velikim ekranom.', 13999.99, 1, 105, 'lg_gram_17.jpg', 'Intel i7, 16GB RAM, 1TB SSD, 17" WQXGA', '2023-01-19'),
	(20, 'Acer Chromebook Spin 713', 'Konvertibilno Chromebook računalo.', 6999.99, 1, 110, 'acer_chromebook_spin_713.jpg', 'Intel i5, 8GB RAM, 128GB SSD, 13.5" 2K', '2023-01-20'),
	(21, 'Dell Latitude 7420', 'Poslovno prijenosno računalo s dugim trajanjem baterije.', 13999.99, 1, 115, 'dell_latitude_7420.jpg', 'Intel i7, 16GB RAM, 512GB SSD, 14" FHD', '2023-01-21'),
	(22, 'Lenovo Yoga 7i', 'Konvertibilno prijenosno računalo s dugim trajanjem baterije.', 10999.99, 1, 120, 'lenovo_yoga_7i.jpg', 'Intel i5, 8GB RAM, 512GB SSD, 14" FHD', '2023-01-22'),
	(23, 'Razer Blade Stealth 13', 'Gaming prijenosno računalo s malim form factorom.', 13999.99, 1, 125, 'razer_blade_stealth_13.jpg', 'Intel i7, 16GB RAM, GTX 1650, 13.3" FHD', '2023-01-23'),
	(24, 'Microsoft Surface Pro 7', 'Hibridno računalo s dodirnim ekranom.', 9999.99, 1, 130, 'microsoft_surface_pro_7.jpg', 'Intel i5, 8GB RAM, 256GB SSD, 12.3" PixelSense', '2023-01-24'),
	(25, 'HP Envy x360', 'Konvertibilno prijenosno računalo s AMD procesorom.', 10999.99, 1, 135, 'hp_envy_x360.jpg', 'AMD Ryzen 5, 8GB RAM, 512GB SSD, 15.6" FHD', '2023-01-25'),
	(26, 'ASUS ZenBook 14', 'Prijenosno računalo s tankim dizajnom.', 9999.99, 1, 140, 'asus_zenbook_14.jpg', 'Intel i7, 16GB RAM, 1TB SSD, 14" FHD', '2023-01-26'),
	(27, 'Acer Predator Helios 300', 'Gaming prijenosno računalo s vrhunskim performansama.', 15999.99, 1, 145, 'acer_predator_helios_300.jpg', 'Intel i7, 16GB RAM, RTX 3060, 15.6" FHD', '2023-01-27'),
	(28, 'Gigabyte AORUS 15G', 'Gaming prijenosno računalo s mehaničkom tipkovnicom.', 18999.99, 1, 150, 'gigabyte_aorus_15g.jpg', 'Intel i7, 16GB RAM, RTX 3070, 15.6" FHD', '2023-01-28'),
	(29, 'MSI GF65 Thin', 'Lagano gaming prijenosno računalo.', 10999.99, 1, 155, 'msi_gf65_thin.jpg', 'Intel i5, 8GB RAM, GTX 1660 Ti, 15.6" FHD', '2023-01-29'),
	(30, 'ASUS TUF Gaming A15', 'Robusno gaming prijenosno računalo.', 12999.99, 1, 160, 'asus_tuf_gaming_a15.jpg', 'AMD Ryzen 5, 16GB RAM, GTX 1660 Ti, 15.6" FHD', '2023-01-30'),
	(31, 'HP Pavilion Desktop', 'Desktop računalo za svakodnevnu upotrebu.', 4999.99, 2, 50, 'hp_pavilion_desktop.jpg', 'Intel i5, 8GB RAM, 1TB HDD', '2023-01-01'),
	(32, 'Dell Inspiron Desktop', 'Desktop računalo s odličnim performansama.', 5999.99, 2, 30, 'dell_inspiron_desktop.jpg', 'Intel i7, 16GB RAM, 512GB SSD', '2023-01-02'),
	(33, 'Lenovo IdeaCentre 510A', 'Svestrano desktop računalo.', 4499.99, 2, 25, 'lenovo_ideacentre_510a.jpg', 'AMD Ryzen 5, 8GB RAM, 1TB HDD', '2023-01-03'),
	(34, 'Acer Aspire TC', 'Desktop računalo za rad i zabavu.', 4999.99, 2, 20, 'acer_aspire_tc.jpg', 'Intel i5, 12GB RAM, 1TB HDD', '2023-01-04'),
	(35, 'ASUS ROG Strix GA15', 'Gaming desktop računalo.', 9999.99, 2, 40, 'asus_rog_strix_ga15.jpg', 'Ryzen 7, 16GB RAM, RTX 2060', '2023-01-05'),
	(36, 'HP Elite Series', 'Poslovno desktop računalo.', 7999.99, 2, 45, 'hp_elite_series.jpg', 'Intel i7, 16GB RAM, 512GB SSD', '2023-01-06'),
	(37, 'Dell XPS Desktop', 'Visokokvalitetno desktop računalo.', 10999.99, 2, 50, 'dell_xps_desktop.jpg', 'Intel i9, 32GB RAM, 1TB SSD', '2023-01-07'),
	(38, 'Lenovo ThinkCentre M720', 'Poslovno desktop računalo.', 5999.99, 2, 55, 'lenovo_thinkcentre_m720.jpg', 'Intel i5, 8GB RAM, 256GB SSD', '2023-01-08'),
	(39, 'Acer Aspire C24', 'All-in-one desktop računalo.', 6999.99, 2, 60, 'acer_aspire_c24.jpg', 'Intel i5, 12GB RAM, 1TB HDD', '2023-01-09'),
	(40, 'ASUS VivoPC', 'Kompakt desktop računalo.', 3999.99, 2, 65, 'asus_vivopc.jpg', 'Intel Celeron, 4GB RAM, 128GB SSD', '2023-01-10'),
	(41, 'HP ProDesk 400', 'Poslovno desktop računalo.', 4999.99, 2, 70, 'hp_prodesk_400.jpg', 'Intel i5, 8GB RAM, 256GB SSD', '2023-01-11'),
	(42, 'Dell OptiPlex 3080', ' Desktop računalo za poslovne korisnike.', 5499.99, 2, 75, 'dell_optiplex_3080.jpg', 'Intel i5, 8GB RAM, 1TB HDD', '2023-01-12'),
	(43, 'Lenovo ThinkStation P340', 'Radna stanica za profesionalce.', 12999.99, 2, 80, 'lenovo_thinkstation_p340.jpg', 'Intel i7, 16GB RAM, 512GB SSD', '2023-01-13'),
	(44, 'Acer Veriton X', 'Kompakt desktop računalo za poslovanje.', 4999.99, 2, 85, 'acer_veriton_x.jpg', 'Intel i5, 8GB RAM, 256GB SSD', '2023-01-14'),
	(45, 'ASUS ROG Strix GA15DH', 'Gaming desktop računalo s RGB osvjetljenjem.', 10999.99, 2, 90, 'asus_rog_strix_ga15dh.jpg', 'AMD Ryzen 5, 16GB RAM, GTX 1660 Ti', '2023-01-15'),
	(46, 'HP Envy Desktop', 'Desktop računalo s modernim dizajnom.', 7999.99, 2, 95, 'hp_envy_desktop.jpg', 'Intel i7, 16GB RAM, 1TB SSD', '2023-01-16'),
	(47, 'Dell G5 Gaming Desktop', 'Gaming desktop računalo s odličnim performansama.', 10999.99, 2, 100, 'dell_g5_gaming_desktop.jpg', 'Intel i7, 16GB RAM, RTX 2060', '2023-01-17'),
	(48, 'Lenovo Legion Tower 5', 'Gaming desktop računalo s RGB osvjetljenjem.', 12999.99, 2, 105, 'lenovo_legion_tower_5.jpg', 'AMD Ryzen 7, 16GB RAM, RTX 3060', '2023-01-18'),
	(49, 'Acer Predator Orion 3000', 'Gaming desktop računalo s vrhunskim performansama.', 13999.99, 2, 110, 'acer_predator_orion_3000.jpg', 'Intel i7, 16GB RAM, RTX 3070', '2023-01-19'),
	(50, 'ASUS ProArt PA90', 'Radna stanica za kreativne profesionalce.', 15999.99, 2, 115, 'asus_proart_pa90.jpg', 'Intel i9, 32GB RAM, 1TB SSD', '2023-01-20'),
	(51, 'HP Z2 Mini G4', 'Kompakt radna stanica.', 13999.99, 2, 120, 'hp_z2_mini_g4.jpg', 'Intel i7, 16GB RAM, 512GB SSD', '2023-01-21'),
	(52, 'Dell Precision 3650', 'Radna stanica za profesionalce.', 17999.99, 2, 125, 'dell_precision_3650.jpg', 'Intel i9, 32GB RAM, 1TB SSD', '2023-01-22'),
	(53, 'Lenovo ThinkStation P520', 'Radna stanica s visokim performansama.', 19999.99, 2, 130, 'lenovo_thinkstation_p520.jpg', 'Intel Xeon, 32GB RAM, 1TB SSD', '2023-01-23'),
	(54, 'Acer Aspire Z24', 'All-in-one desktop računalo.', 7999.99, 2, 135, 'acer_aspire_z24.jpg', 'Intel i5, 12GB RAM, 1TB HDD', '2023-01-24'),
	(55, 'ASUS Zen AiO 24', 'Elegantno all-in-one desktop računalo.', 9999.99, 2, 140, 'asus_zen_aio_24.jpg', 'Intel i7, 16GB RAM, 512GB SSD', '2023-01-25'),
	(56, 'HP All-in-One 24', 'Svestrano all-in-one desktop računalo.', 8499.99, 2, 145, 'hp_all_in_one_24.jpg', 'AMD Ryzen 5, 8GB RAM, 1TB HDD', '2023-01-26'),
	(57, 'Dell Inspiron 24 5000', 'All-in-one desktop računalo s modernim dizajnom.', 8999.99, 2, 150, 'dell_inspiron_24_5000.jpg', 'Intel i5,  8GB RAM, 512GB SSD', '2023-01-27'),
	(58, 'Lenovo IdeaCentre AIO 3', 'All-in-one desktop računalo s odličnim performansama.', 7499.99, 2, 155, 'lenovo_ideacentre_aio_3.jpg', 'AMD Ryzen 5, 8GB RAM, 1TB HDD', '2023-01-28'),
	(59, 'Acer Aspire C22', 'Kompakt all-in-one desktop računalo.', 6999.99, 2, 160, 'acer_aspire_c22.jpg', 'Intel i3, 4GB RAM, 128GB SSD', '2023-01-29'),
	(60, 'ASUS Vivo AiO V241', 'Elegantno all-in-one desktop računalo.', 8499.99, 2, 165, 'asus_vivo_aio_v241.jpg', 'Intel i5, 8GB RAM, 512GB SSD', '2023-01-30'),
	(61, 'Dell UltraSharp U2720Q', '27-inčni 4K monitor.', 4999.99, 3, 50, 'dell_ultrasharp_u2720q.jpg', '27" 4K UHD, IPS, 99% sRGB', '2023-01-01'),
	(62, 'LG 27UK850-W', '27-inčni 4K UHD monitor.', 4499.99, 3, 30, 'lg_27uk850_w.jpg', '27" 4K UHD, HDR10, USB-C', '2023-01-02'),
	(63, 'BenQ PD3220U', '27-inčni 4K monitor za dizajn.', 5999.99, 3, 25, 'benq_pd3220u.jpg', '27" 4K UHD, 95% P3', '2023-01-03'),
	(64, 'ASUS ProArt PA32UCX', '32-inčni 4K HDR monitor.', 19999.99, 3, 20, 'asus_proart_pa32ucx.jpg', '32" 4K UHD, HDR, 99% Adobe RGB', '2023-01-04'),
	(65, 'Samsung Odyssey G7', '27-inčni gaming monitor.', 4999.99, 3, 40, 'samsung_odyssey_g7.jpg', '27" QHD, 240Hz, G-Sync', '2023-01-05'),
	(66, 'Acer Predator X27', '27-inčni gaming monitor.', 19999.99, 3, 15, 'acer_predator_x27.jpg', '27" 4K UHD, 144Hz, G-Sync', '2023-01-06'),
	(67, 'LG 34WK95U-W', '34-inčni ultrawide monitor.', 10999.99, 3, 10, 'lg_34wk95u_w.jpg', '34" 5K2K, Nano IPS, HDR', '2023-01-07'),
	(68, 'Dell P2720DC', '27-inčni QHD monitor.', 3499.99, 3, 55, 'dell_p2720dc.jpg', '27" QHD, IPS, USB-C', '2023-01-08'),
	(69, 'ASUS ROG Swift PG32UQX', '32-inčni gaming monitor.', 24999.99, 3, 60, 'asus_rog_swift_pg32uqx.jpg', '32" 4K UHD, 144Hz, G-Sync', '2023-01-09'),
	(70, 'ViewSonic VP2768a-4K', '27-inčni 4K monitor za profesionalce.', 5999.99, 3, 65, 'viewsonic_vp2768a_4k.jpg', '27" 4K UHD, 100% sRGB', '2023-01-10'),
	(71, 'HP Z27', '27-inčni 4K monitor.', 6999.99, 3, 70, 'hp_z27.jpg', '27" 4K UHD, IPS, 99% sRGB', '2023-01-11'),
	(72, 'Eizo ColorEdge CG319X', '31-inčni 4K monitor za dizajn.', 49999.99, 3, 75, 'eizo_coloredge_cg319x.jpg', '31" 4K UHD, 99% Adobe RGB', '2023-01-12'),
	(73, 'Samsung CHG90', '49-inčni ultrawide gaming monitor.', 19999.99, 3, 80, 'samsung_chg90.jpg', '49" QLED, 144Hz, FreeSync', '2023-01-13'),
	(74, 'LG 38WN95C-W', '38-inčni ultrawide monitor.', 14999.99, 3, 85, 'lg_38wn95c_w.jpg', '38" 3840x1600, Nano IPS, HDR', '2023-01-14'),
	(75, 'Acer R240HY', '24-inčni IPS monitor.', 2499.99, 3, 90, 'acer_r240hy.jpg', '24" Full HD, IPS, 75Hz', '2023-01-15'),
	(76, 'BenQ GW2480', '24-inčni monitor s bezokvirnim dizajnom.', 2999.99, 3, 95, 'benq_gw2480.jpg', '24" Full HD, IPS, 60Hz', '2023-01-16'),
	(77, 'Dell S2721D', '27-inčni QHD monitor.', 3999.99, 3, 100, 'dell_s2721d.jpg', '27" QHD, IPS, 75Hz', '2023-01-17'),
	(78, 'ASUS TUF Gaming VG27AQ', '27-inčni gaming monitor.', 5999.99, 3, 105, 'asus_tuf_gaming_vg27aq.jpg', '27" QHD, 165Hz, G-Sync', '2023-01-18'),
	(79, 'ViewSonic XG2405', '24-inčni gaming monitor.', 3499.99, 3, 110, 'viewsonic_xg2405.jpg', '24" Full HD, 144Hz, FreeSync', '2023-01-19'),
	(80, 'LG 27GL850-B', '27-inčni gaming monitor.', 6999.99, 3, 115, 'lg_27gl850_b.jpg', '27" QHD, 144Hz, G-Sync', '2023-01-20'),
	(81, 'Acer Nitro VG271', '27-inčni gaming monitor.', 4999.99, 3, 120, 'acer_nitro_vg271.jpg', '27" Full HD, 144Hz, FreeSync', '2023-01-21'),
	(82, 'Samsung Odyssey G5', '32-inčni gaming monitor.', 4999.99, 3, 125, 'samsung_odyssey_g5.jpg', '32" QHD, 144Hz, FreeSync', '2023-01-22'),
	(83, 'Dell U3219Q', '32-inčni 4K monitor.', 9999.99, 3, 130, 'dell_u3219q.jpg', '32" 4K UHD, IPS, 95% DCI-P3', '2023-01-23'),
	(84, 'ASUS ProArt PA27AC', '27-inčni 4K monitor za kreativne profesionalce.', 7999.99, 3, 135, 'asus_proart_pa27ac.jpg', '27" 4K UHD, HDR, 100% sRGB', '2023-01-24'),
	(85, 'BenQ PD2725U', '27-inčni 4K monitor za dizajn.', 8999.99, 3, 140, 'benq_pd2725u.jpg', '27" 4K UHD, 95% P3', '2023-01-25'),
	(86, 'LG 32UN880-B', '32-inčni 4K monitor s ergonomskim postoljem.', 12999.99, 3, 145, 'lg_32un880_b.jpg', '32" 4K UHD, HDR10', '2023-01-26'),
	(87, 'Eizo FlexScan EV2785', '27-inčni 4K monitor.', 12999.99, 3, 150, 'eizo_flexscan_ev2785.jpg', '27" 4K UHD, IPS, 99% sRGB', '2023-01-27'),
	(88, 'Samsung S80A', '27-inčni 4K monitor.', 5999.99, 3, 155, 'samsung_s80a.jpg', '27" 4K UHD, IPS, 99% sRGB', '2023-01-28'),
	(89, 'Acer CB272U', '27-inčni QHD monitor.', 4999.99, 3, 160, ' acer_cb272u.jpg', '27" QHD, IPS, 75Hz', '2023-01-29'),
	(90, 'Logitech G Pro X', 'Mehanička gaming tipkovnica.', 899.99, 4, 50, 'logitech_g_pro_x.jpg', 'RGB, GX Blue Switches', '2023-01-01'),
	(91, 'Razer BlackWidow V3', 'Mehanička gaming tipkovnica.', 1099.99, 4, 30, 'razer_blackwidow_v3.jpg', 'RGB, Green Switches', '2023-01-02'),
	(92, 'Corsair K95 RGB Platinum', 'Mehanička tipkovnica s RGB osvjetljenjem.', 1399.99, 4, 25, 'corsair_k95_rgb_platinum.jpg', 'Cherry MX, RGB', '2023-01-03'),
	(93, 'Logitech K800', 'Bežična tipkovnica s pozadinskim osvjetljenjem.', 699.99, 4, 20, 'logitech_k800.jpg', 'Bežična, pozadinsko osvjetljenje', '2023-01-04'),
	(94, 'Microsoft Sculpt Ergonomic', 'Ergonomska tipkovnica.', 899.99, 4, 40, 'microsoft_sculpt_ergonomic.jpg', 'Ergonomska, bežična', '2023-01-05'),
	(95, 'Razer Huntsman Elite', 'Mehanička tipkovnica s optičkim prekidačima.', 1399.99, 4, 15, 'razer_huntsman_elite.jpg', 'Optical Switches, RGB', '2023-01-06'),
	(96, 'SteelSeries Apex Pro', 'Mehanička tipkovnica s prilagodljivim prekidačima.', 1599.99, 4, 10, 'steelseries_apex_pro.jpg', 'Adjustable Switches, RGB', '2023-01-07'),
	(97, 'HyperX Alloy FPS Pro', 'Kompakt mehanička tipkovnica.', 799.99, 4, 55, 'hyperx_alloy_fps_pro.jpg', 'Cherry MX, kompakt', '2023-01-08'),
	(98, 'Logitech G915', 'Tanka mehanička gaming tipkovnica.', 1899.99, 4, 60, 'logitech_g915.jpg', 'Low Profile, RGB', '2023-01-09'),
	(99, 'ASUS ROG Strix Scope', 'Gaming tipkovnica sa širokim tipkama.', 1099.99, 4, 65, 'asus_rog_strix_scope.jpg', 'Cherry MX, RGB', '2023-01-10'),
	(100, 'Ducky One 2 Mini', 'Kompakt mehanička tipkovnica.', 899.99, 4, 70, 'ducky_one_2_mini.jpg', 'Cherry MX, kompakt', '2023-01-11'),
	(101, 'Cooler Master CK530', 'Mehanička tipkovnica s RGB osvjetljenjem.', 699.99, 4, 75, 'cooler_master_ck530.jpg', 'RGB, mekan', '2023-01-12'),
	(102, 'Keychron K6', 'Bežična mehanička tipkovnica.', 799.99, 4, 80, 'keychron_k6.jpg', 'Bežična, kompakt', '2023-01-13'),
	(103, 'Logitech K380', 'Bežična tipkovnica za više uređaja.', 399.99, 4, 85, 'logitech_k380.jpg', 'Bežična, za više uređaja', '2023-01-14'),
	(104, 'Razer Cynosa V2', 'Membranska gaming tipkovnica.', 599.99, 4, 90, 'razer_cynosa_v2.jpg', 'Membranska, RGB', '2023-01-15'),
	(105, 'Corsair K55 RGB', 'Membranska gaming tipkovnica.', 499.99, 4, 95, 'corsair_k55_rgb.jpg', 'Membranska, RGB', '2023-01-16'),
	(106, 'Logitech G213', 'Membranska gaming tipkovnica.', 599.99, 4, 100, 'logitech_g 213.jpg', 'Membranska, RGB', '2023-01-17'),
	(107, 'Razer Ornata V2', 'Hibridna gaming tipkovnica.', 799.99, 4, 105, 'razer_ornata_v2.jpg', 'Hibridna, RGB', '2023-01-18'),
	(108, 'SteelSeries Apex 7', 'Mehanička tipkovnica s RGB osvjetljenjem.', 1299.99, 4, 110, 'steelseries_apex_7.jpg', 'Cherry MX, RGB', '2023-01-19'),
	(109, 'HyperX Alloy Elite 2', 'Mehanička gaming tipkovnica.', 1399.99, 4, 115, 'hyperx_alloy_elite_2.jpg', 'Cherry MX, RGB', '2023-01-20'),
	(110, 'Razer BlackWidow Lite', 'Mehanička tipkovnica bez RGB osvjetljenja.', 899.99, 4, 120, 'razer_blackwidow_lite.jpg', 'Orange Switches', '2023-01-21'),
	(111, 'Logitech G413', 'Mehanička gaming tipkovnica.', 899.99, 4, 125, 'logitech_g413.jpg', 'Red Switches', '2023-01-22'),
	(112, 'Corsair K70 RGB MK.2', 'Mehanička gaming tipkovnica.', 1599.99, 4, 130, 'corsair_k70_rgb_mk2.jpg', 'Cherry MX, RGB', '2023-01-23'),
	(113, 'Razer Huntsman Mini', 'Kompakt mehanička tipkovnica.', 999.99, 4, 135, 'razer_huntsman_mini.jpg', 'Optical Switches, RGB', '2023-01-24'),
	(114, 'Ducky One 3', 'Mehanička tipkovnica s RGB osvjetljenjem.', 1099.99, 4, 140, 'ducky_one_3.jpg', 'Cherry MX, RGB', '2023-01-25'),
	(115, 'Logitech G Pro TKL', 'Kompakt mehanička gaming tipkovnica.', 1099.99, 4, 145, 'logitech_g_pro_tkl.jpg', 'RGB, GX Blue Switches', '2023-01-26'),
	(116, 'Razer BlackWidow V3 Tenkeyless', 'Kompakt mehanička gaming tipkovnica.', 1099.99, 4, 150, 'razer_blackwidow_v3_tkl.jpg', 'RGB, Green Switches', '2023-01-27'),
	(117, 'Cooler Master CK721', 'Bežična mehanička tipkovnica.', 899.99, 4, 155, 'cooler_master_ck721.jpg', 'RGB, bežična', '2023-01-28'),
	(118, 'Keychron K1', 'Tanka bežična mehanička tipkovnica.', 799.99, 4, 160, 'keychron_k1.jpg', 'Bežična, RGB', '2023-01-29'),
	(119, 'Logitech G915 TKL', 'Tanka mehanička gaming tipkovnica.', 1899.99, 4, 165, 'logitech_g915_tkl.jpg', 'Low Profile, RGB', '2023-01-30'),
	(120, 'Logitech G502 HERO', 'Gaming miš s visokom preciznošću.', 499.99, 5, 50, 'logitech_g502_hero.jpg', '16,000 DPI, RGB', '2023-01-01'),
	(121, 'Razer DeathAdder V2', 'Ergonomski gaming miš.', 599.99, 5, 30, 'razer_deathadder_v2.jpg', '20,000 DPI, RGB', '2023-01-02'),
	(122, 'SteelSeries Rival 600', 'Gaming miš s dvostrukim senzorom.', 699.99, 5, 25, 'steelseries_rival_600.jpg', '12,000 DPI, RGB', '2023-01-03'),
	(123, 'Corsair Scimitar RGB', 'Gaming miš s programabilnim tipkama.', 799.99, 5, 20, 'corsair_scimitar_rgb.jpg', '16,000 DPI, RGB', '2023-01-04'),
	(124, 'Logitech MX Master  3', 'Bežični miš s naprednim funkcijama.', 899.99, 5, 40, 'logitech_mx_master_3.jpg', '4000 DPI, bežični', '2023-01-05'),
	(125, 'Razer Naga X', 'Gaming miš s 16 programabilnih tipki.', 699.99, 5, 15, 'razer_naga_x.jpg', '16,000 DPI, RGB', '2023-01-06'),
	(126, 'Zowie EC2', 'Gaming miš s ergonomskim dizajnom.', 499.99, 5, 10, 'zowie_ec2.jpg', '3200 DPI, bez RGB', '2023-01-07'),
	(127, 'Glorious Model O', 'Lagani gaming miš s perforiranim dizajnom.', 799.99, 5, 55, 'glorious_model_o.jpg', '12,000 DPI, RGB', '2023-01-08'),
	(128, 'Logitech G Pro Wireless', 'Bežični gaming miš s visokom preciznošću.', 999.99, 5, 60, 'logitech_g_pro_wireless.jpg', '25,600 DPI, RGB', '2023-01-09'),
	(129, 'Razer Viper Ultimate', 'Bežični gaming miš s optičkim prekidačima.', 1099.99, 5, 65, 'razer_viper_ultimate.jpg', '20,000 DPI, RGB', '2023-01-10'),
	(130, 'Corsair M65 RGB Elite', 'Gaming miš s prilagodljivim težinama.', 799.99, 5, 70, 'corsair_m65_rgb_elite.jpg', '18,000 DPI, RGB', '2023-01-11'),
	(131, 'HyperX Pulsefire FPS Pro', 'Gaming miš s preciznim senzorom.', 599.99, 5, 75, 'hyperx_pulsefire_fps_pro.jpg', '16,000 DPI, RGB', '2023-01-12'),
	(132, 'Razer Basilisk V3', 'Gaming miš s prilagodljivim kotačićem.', 899.99, 5, 80, 'razer_basilisk_v3.jpg', '26,000 DPI, RGB', '2023-01-13'),
	(133, 'Logitech G305 LIGHTSPEED', 'Bežični gaming miš s dugim trajanjem baterije.', 699.99, 5, 85, 'logitech_g305_lightspeed.jpg', '12,000 DPI, RGB', '2023-01-14'),
	(134, 'SteelSeries Sensei Ten', 'Gaming miš s ambidextrous dizajnom.', 599.99, 5, 90, 'steelseries_sensei_ten.jpg', '18,000 DPI, RGB', '2023-01-15'),
	(135, 'Razer Atheris', 'Bežični miš za produktivnost.', 499.99, 5, 95, 'razer_atheris.jpg', '7200 DPI, bežični', '2023-01-16'),
	(136, 'Logitech G703 LIGHTSPEED', 'Bežični gaming miš s RGB osvjetljenjem.', 999.99, 5, 100, 'logitech_g703_lightspeed.jpg', '16,000 DPI, RGB', '2023-01-17'),
	(137, 'Corsair Katar Pro', 'Lagani gaming miš.', 399.99, 5, 105, 'corsair_katar_pro.jpg', '12,000 DPI, RGB', '2023-01-18'),
	(138, 'Razer Orochi V2', 'Bežični gaming miš s dugim trajanjem baterije.', 699.99, 5, 110, 'razer_orochi_v2.jpg', '18,000 DPI, RGB', '2023-01-19'),
	(139, 'Logitech G203 LIGHTSYNC', 'Gaming miš s RGB osvjetljenjem.', 399.99, 5, 115, 'logitech_g203_lightsync.jpg', '8000 DPI, RGB', '2023-01-20'),
	(140, 'SteelSeries Rival 3', 'Gaming miš s dugim trajanjem baterije.', 499.99, 5, 120, 'steelseries_rival_3.jpg', '8,500 DPI, RGB', '2023-01-21'),
	(141, 'Razer Mamba Wireless', 'Bežični gaming miš s ergonomskim dizajnom.', 899.99, 5, 125, 'razer_mamba_wireless.jpg', '16,000 DPI, RGB', '2023-01-22'),
	(142, 'Razer Viper Mini', 'Mali bežični gaming miš.', 499.99, 5, 135, 'razer_viper_mini.jpg', '16,000 DPI, RGB', '2023-01-24'),
	(143, 'Corsair Harpoon RGB Wireless', 'Bežični gaming miš s RGB osvjetljenjem.', 699.99, 5, 140, 'corsair_harpoon_rgb_wireless.jpg', '10,000 DPI, RGB', '2023-01-25'),
	(144, 'Logitech MX Anywhere 3', 'Bežični miš za produktivnost.', 899.99, 5, 145, 'logitech_mx_anywhere_3.jpg', '4000 DPI, bežični', '2023-01-26'),
	(145, 'Razer Atheris', 'Bežični miš za mobilne korisnike.', 499.99, 5, 150, 'razer_atheris.jpg', '7200 DPI, bežični', '2023-01-27'),
	(146, 'NVIDIA GeForce RTX 3080', 'Grafička kartica za gaming i profesionalnu upotrebu.', 6999.99, 6, 50, 'nvidia_geforce_rtx_3080.jpg', '10GB GDDR6X', '2023-01-01'),
	(147, 'AMD Radeon RX 6800 XT', 'Grafička kartica za visoke performanse.', 6499.99, 6, 30, 'amd_radeon_rx_6800_xt.jpg', '16GB GDDR6', '2023-01-02'),
	(148, 'NVIDIA GeForce RTX 3070', 'Grafička kartica za gaming.', 4999.99, 6, 25, 'nvidia_geforce_rtx_3070.jpg', '8GB GDDR6', '2023-01-03'),
	(149, 'AMD Radeon RX 6700 XT', 'Grafička kartica za 1440p gaming.', 3999.99, 6, 20, 'amd_radeon_rx_6700_xt.jpg', '12GB GDDR6', '2023-01-04'),
	(150, 'NVIDIA GeForce GTX 1660 Super', 'Grafička kartica za budget gaming.', 2499.99, 6, 40, 'nvidia_geforce_gtx_1660_super.jpg', '6GB GDDR6', '2023-01-05'),
	(151, 'AMD Radeon RX 580', 'Grafička kartica za 1080p gaming.', 1999.99, 6, 15, 'amd_radeon_rx_580.jpg', '8GB GDDR5', '2023-01-06'),
	(152, 'NVIDIA GeForce RTX 3060 Ti', 'Grafička kartica za visoke performanse.', 3999.99, 6, 10, 'nvidia_geforce_rtx_3060_ti.jpg', '8GB GDDR6', '2023-01-07'),
	(153, 'AMD Radeon RX 5600 XT', 'Grafička kartica za 1080p gaming.', 2999.99, 6, 55, 'amd_radeon_rx_5600_xt.jpg', '6GB GDDR6', '2023-01-08'),
	(154, 'NVIDIA GeForce GTX 1650', 'Grafička kartica za osnovne igre.', 1499.99, 6, 60, 'nvidia_geforce_gtx_1650.jpg', '4GB GDDR5', '2023-01-09'),
	(155, 'AMD Radeon RX 5500 XT', 'Grafička kartica za budget gaming.', 1999.99, 6, 65, 'amd_radeon_rx_5500_xt.jpg', '4GB GDDR6', '2023-01-10'),
	(156, 'NVIDIA GeForce RTX 3090', 'Grafička kartica za profesionalce.', 14999.99, 6, 70, 'nvidia_geforce_rtx_3090.jpg', '24GB GDDR6X', '2023-01-11'),
	(157, 'AMD Radeon Pro VII', 'Grafička kartica za profesionalnu upotrebu.', 19999.99, 6, 75, 'amd_radeon_pro_vii.jpg', '16GB HBM2', '2023-01-12'),
	(158, 'NVIDIA GeForce RTX 2080 Ti', 'Grafička kartica za visoke performanse.', 9999.99, 6, 80, 'nvidia_geforce_rtx_2080_ti.jpg', '11GB GDDR6', '2023-01-13'),
	(159, 'AMD Radeon RX 5700 XT', 'Grafička kartica za 1440p gaming.', 3499.99, 6, 85, 'amd_radeon_rx_5700_xt.jpg', '8GB GDDR6', '2023-01-14'),
	(160, 'NVIDIA GeForce GTX 1070', 'Grafička kartica za 1080p gaming.', 2499.99, 6, 90, 'nvidia_geforce_gtx_1070.jpg', '8GB GDDR5', '2023-01-15'),
	(161, 'AMD Radeon RX 590', 'Grafička kartica za budget gaming.', 1999.99, 6, 95, 'amd_radeon_rx_590.jpg', '8GB GDDR5', '2023-01-16'),
	(162, 'NVIDIA GeForce GTX 1660 Ti', 'Grafička kartica za budget gaming.', 2999.99, 6, 100, 'nvidia_geforce_gtx_1660_ti.jpg', '6GB GDDR6', '2023-01-17'),
	(163, 'AMD Radeon RX 6700', 'Grafička kartica za 1440p gaming.', 3999.99, 6, 105, 'amd_radeon_rx_6700.jpg', '12GB GDDR6', '2023-01-18'),
	(164, 'NVIDIA GeForce RTX 3050', 'Grafička kartica za osnovne igre.', 1999.99, 6, 110, 'nvidia_geforce_rtx_3050.jpg', '8GB GDDR6', '2023-01-19'),
	(165, 'AMD Radeon RX 6400', 'Grafička kartica za osnovne igre.', 1499.99, 6, 115, 'amd_radeon_rx_6400.jpg', '4GB GDDR6', '2023-01-20'),
	(166, 'NVIDIA GeForce GTX 1650 Super', 'Grafička kartica za budget gaming.', 1799.99, 6, 120, 'nvidia_geforce_gtx_1650_super.jpg', '4GB GDDR6', '2023-01-21'),
	(167, 'AMD Radeon RX 5500', 'Grafička kartica za osnovne igre.', 1599.99, 6, 125, 'amd_radeon_rx_5500.jpg', '4GB GDDR6', '2023-01-22'),
	(168, 'NVIDIA GeForce RTX 2060', 'Grafička kartica za 1080p gaming.', 2999.99, 6, 130, 'nvidia_geforce_rtx_2060.jpg', '6GB GDDR6', '2023-01-23'),
	(169, 'AMD Radeon RX 5300', 'Grafička kartica za osnovne igre.', 1299.99, 6, 135, 'amd_radeon_rx_5300.jpg', '3GB GDDR6', '2023-01-24'),
	(170, 'NVIDIA GeForce GTX 960', 'Grafička kartica za starije igre.', 999.99, 6, 140, 'nvidia_geforce_gtx_960.jpg', '4GB GDDR5', '2023-01-25'),
	(171, 'AMD Radeon R9 380', 'Grafička kartica za starije igre.', 899.99, 6, 145, 'amd_radeon_r9_380.jpg', '4GB GDDR5', '2023-01-26'),
	(172, 'NVIDIA GeForce GTX 750 Ti', 'Grafička kartica za osnovne igre.', 699.99, 6, 150, 'nvidia_geforce_gtx_750_ti.jpg', '2GB GDDR5', '2023-01-27'),
	(173, 'AMD Radeon R7 250', 'Grafička kartica za osnovne igre.', 499.99, 6, 155, 'amd_radeon_r7_250.jpg', '1GB GDDR5', '2023-01-28'),
	(174, 'Seagate Barracuda 1TB', 'HDD za pohranu podataka.', 399.99, 7, 100, 'seagate_barracuda_1tb.jpg', '1TB, 7200 RPM', '2023-01-01'),
	(175, 'Western Digital Blue 2TB', 'HDD za pohranu podataka.', 499.99, 7, 90, 'wd_blue_2tb.jpg', '2TB, 5400 RPM', '2023-01-02'),
	(176, 'Toshiba X300 4TB', 'HDD za gaming i pohranu.', 799.99, 7, 80, 'toshiba_x300_4tb.jpg', '4TB, 7200 RPM', '2023-01-03'),
	(177, 'Seagate IronWolf 8TB', 'HDD za NAS uređaje.', 1399.99, 7, 70, 'seagate_ironwolf_8tb.jpg', '8TB, 7200 RPM', '2023-01-04'),
	(178, 'Western Digital Black 1TB', 'Visokoperformantni HDD.', 599.99, 7, 60, 'wd_black_1tb.jpg', '1TB, 7200 RPM', '2023-01-05'),
	(179, 'Samsung 970 EVO Plus 1TB', 'NVMe SSD za brzu pohranu.', 899.99, 7, 50, 'samsung_970_evo_plus_1tb.jpg', '1TB, NVMe', '2023-01-06'),
	(180, 'Crucial MX500 500GB', 'SATA SSD za pohranu.', 499.99, 7, 40, 'crucial_mx500_500gb.jpg', '500GB, SATA III', '2023-01-07'),
	(181, 'Kingston A2000 1TB', 'NVMe SSD za brzu pohranu.', 699.99, 7, 30, 'kingston_a2000_1tb.jpg', '1TB, NVMe', '2023-01-08'),
	(182, 'SanDisk Ultra 2TB', 'SATA SSD za pohranu.', 1099.99, 7, 20, 'sandisk_ultra_2tb.jpg', '2TB, SATA III', '2023-01-09'),
	(183, 'ADATA XPG SX8200 Pro 1TB', 'NVMe SSD za gaming.', 799.99, 7, 10, 'adata_xpg_sx8200_pro_1tb.jpg', '1TB, NVMe', '2023-01-10'),
	(184, 'Samsung 860 EVO 2TB', 'SATA SSD za pohranu.', 1399.99, 7, 5, 'samsung_860_evo_2tb.jpg', '2TB, SATA III', '2023-01-11'),
	(185, 'Seagate FireCuda 2TB', 'Hibridni HDD za gaming.', 899.99, 7, 15, 'seagate_firecuda_2tb.jpg', '2TB, 7200 RPM', '2023-01-12'),
	(186, 'Western Digital Red 4TB', 'HDD za NAS uređaje.', 999.99, 7, 25, 'wd_red_4tb.jpg', '4TB, 5400 RPM', '2023-01-13'),
	(187, 'Toshiba DT01ACA300 3TB', 'HDD za pohranu podataka.', 699.99, 7, 35, 'toshiba_dt01aca300_3tb.jpg', '3TB, 7200 RPM', '2023-01-14'),
	(188, 'Crucial P3 1TB', 'NVMe SSD za pohranu.', 599.99, 7, 45, 'crucial_p3_1tb.jpg', '1TB, NVMe', '2023-01-15'),
	(189, 'Kingston NV1 500GB', 'NVMe SSD za osnovne potrebe.', 399.99, 7, 55, 'kingston_nv1_500gb.jpg', '500GB, NVMe', '2023-01-16'),
	(190, 'Samsung 870 QVO 2TB', 'SATA SSD za pohranu.', 1099.99, 7, 65, 'samsung_870_qvo_2tb.jpg', '2TB, SATA III', '2023-01-17'),
	(191, 'ADATA SU800  1TB', 'SATA SSD za pohranu.', 699.99, 7, 75, 'adata_su800_1tb.jpg', '1TB, SATA III', '2023-01-18'),
	(192, 'Seagate Barracuda 8TB', 'HDD za pohranu podataka.', 1599.99, 7, 85, 'seagate_barracuda_8tb.jpg', '8TB, 7200 RPM', '2023-01-19'),
	(193, 'Western Digital Gold 10TB', 'Visokoperformantni HDD za pohranu.', 2499.99, 7, 95, 'wd_gold_10tb.jpg', '10TB, 7200 RPM', '2023-01-20'),
	(194, 'Toshiba N300 6TB', 'HDD za NAS uređaje.', 1199.99, 7, 100, 'toshiba_n300_6tb.jpg', '6TB, 7200 RPM', '2023-01-21'),
	(195, 'Crucial BX500 480GB', 'SATA SSD za osnovne potrebe.', 299.99, 7, 105, 'crucial_bx500_480gb.jpg', '480GB, SATA III', '2023-01-22'),
	(196, 'Samsung 970 EVO 2TB', 'NVMe SSD za brzu pohranu.', 1799.99, 7, 110, 'samsung_970_evo_2tb.jpg', '2TB, NVMe', '2023-01-23'),
	(197, 'Western Digital Blue 1TB', 'HDD za pohranu podataka.', 399.99, 7, 115, 'wd_blue_1tb.jpg', '1TB, 5400 RPM', '2023-01-24'),
	(198, 'Seagate SkyHawk 4TB', 'HDD za nadzorne kamere.', 899.99, 7, 120, 'seagate_skyhawk_4tb.jpg', '4TB, 5900 RPM', '2023-01-25'),
	(199, 'Toshiba L200 1TB', 'HDD za prijenosna računala.', 499.99, 7, 125, 'toshiba_l200_1tb.jpg', '1TB, 5400 RPM', '2023-01-26'),
	(200, 'Crucial MX500 1TB', 'SATA SSD za pohranu.', 699.99, 7, 130, 'crucial_mx500_1tb.jpg', '1TB, SATA III', '2023-01-27'),
	(201, 'Samsung 870 EVO 1TB', 'SATA SSD za pohranu.', 799.99, 7, 135, 'samsung_870_evo_1tb.jpg', '1TB, SATA III', '2023-01-28'),
	(202, 'ADATA XPG SX6000 Pro 1TB', 'NVMe SSD za gaming.', 899.99, 7, 140, 'adata_xpg_sx6000_pro_1tb.jpg', '1TB, NVMe', '2023-01-29'),
	(203, 'Seagate FireCuda 1TB', 'Hibridni HDD za gaming.', 699.99, 7, 145, 'seagate_firecuda_1tb.jpg', '1TB, 7200 RPM', '2023-01-30'),
	(204, 'Corsair Vengeance LPX 16GB', 'DDR4 RAM memorija.', 699.99, 8, 100, 'corsair_vengeance_lpx_16gb.jpg', '16GB, DDR4, 3200MHz', '2023-01-01'),
	(205, 'G.Skill Ripjaws V 16GB', 'DDR4 RAM memorija.', 749.99, 8, 90, 'gskill_ripjaws_v_16gb.jpg', '16GB, DDR4, 3200MHz', '2023-01-02'),
	(206, 'Kingston HyperX Fury 16GB', 'DDR4 RAM memorija.', 699.99, 8, 80, 'kingston_hyperx_fury_16gb.jpg', '16GB, DDR4, 3200MHz', '2023-01-03'),
	(207, 'Corsair Vengeance LPX 32GB', 'DDR4 RAM memorija.', 1399.99, 8, 60, 'corsair_vengeance_lpx_32gb.jpg', '32GB, DDR4, 3200MHz', '2023-01-05'),
	(208, 'G.Skill Ripjaws V 32GB', 'DDR4 RAM memorija.', 1499.99, 8, 50, 'gskill_ripjaws_v_32gb.jpg', '32GB, DDR4, 3200MHz', '2023-01-06'),
	(209, 'Kingston HyperX Fury 32GB', 'DDR4 RAM memorija.', 1399.99, 8, 40, 'kingston_hyperx_fury_32gb.jpg', '32GB, DDR4, 3200MHz', '2023-01-07'),
	(210, 'Crucial Ballistix 32GB', 'DDR4 RAM memorija.', 1299.99, 8, 30, 'crucial_ballistix_32gb.jpg', '32GB, DDR4, 3200MHz', '2023-01-08'),
	(211, 'Corsair Vengeance LPX 8GB', 'DDR4 RAM memorija.', 399.99, 8, 20, 'corsair_vengeance_lpx_8gb.jpg', '8GB, DDR4, 3200MHz', '2023-01-09'),
	(212, 'G.Skill Ripjaws V 8GB', 'DDR4 RAM memorija.', 449.99, 8, 10, 'gskill_ripjaws_v_8gb.jpg', '8GB, DDR4, 3200MHz', '2023-01-10'),
	(213, 'Kingston HyperX Fury 8GB', 'DDR4 RAM memorija.', 399.99, 8, 5, 'kingston_hyperx_fury_8gb.jpg', '8GB, DDR4, 3200MHz', '2023-01-11'),
	(214, 'Crucial Ballistix 8GB', 'DDR4 RAM memorija.', 349.99, 8, 15, 'crucial_ballistix_8gb.jpg', '8GB, DDR4, 3200MHz', '2023-01-12'),
	(215, 'Corsair Vengeance LPX 64GB', 'DDR4 RAM memorija.', 2499.99, 8, 25, 'corsair_vengeance_lpx_64gb.jpg', '64GB, DDR4, 3200MHz', '2023-01-13'),
	(216, 'G.Skill Ripjaws V 64GB', 'DDR4 RAM memorija.', 2599.99, 8, 35, 'gskill_ripjaws_v_64gb.jpg', '64GB, DDR4, 3200MHz', '2023-01-14'),
	(217, 'Kingston HyperX Fury 64GB', 'DDR4 RAM memorija.', 2499.99, 8, 45, 'kingston_hyperx_fury_64gb.jpg', '64GB, DDR4, 3200MHz', '2023-01-15'),
	(218, 'Crucial Ballistix 64GB', 'DDR4 RAM memorija.', 2399.99, 8, 55, 'crucial_ballistix_64gb.jpg', '64GB, DDR4, 3200MHz', '2023-01-16'),
	(219, 'Corsair Vengeance LPX 16GB (2x8GB)', 'DDR4 RAM memorija.', 749.99, 8, 65, 'corsair_vengeance_lpx_16gb_2x8gb.jpg', '16GB (2x8GB), DDR4, 3200MHz', '2023-01-17'),
	(220, 'G.Skill Ripjaws V 16GB (2x8GB)', 'DDR4 RAM memorija.', 799.99, 8, 75, 'gskill_ripjaws_v_16gb_2x8gb.jpg', '16GB (2x8GB), DDR4, 3200MHz', '2023-01-18'),
	(221, 'Kingston HyperX Fury 16GB (2x8GB)', 'DDR4 RAM memorija.', 749.99, 8, 85, 'kingston_hyperx_fury_16gb_2x8gb.jpg', '16GB (2x8GB), DDR4, 3200MHz', '2023-01-19'),
	(222, 'Crucial Ballistix 16GB (2x8GB)', 'DDR4 RAM memorija.', 699.99, 8, 95, 'crucial_ballistix_16gb_2x8gb.jpg', '16GB (2x8GB), DDR4, 3200MHz', '2023-01-20'),
	(223, 'Corsair Vengeance LPX 32GB (2x16GB)', 'DDR4 RAM memorija.', 1399.99, 8, 105, 'corsair_vengeance_lpx_32gb_2x16gb.jpg', '32GB (2x16GB), DDR4, 3200MHz', '2023-01-21'),
	(224, 'G.Skill Ripjaws V 32GB (2x16GB)', 'DDR4 RAM memorija.', 1499.99, 8, 115, 'gskill_ripjaws_v_32gb_2x16gb.jpg', '32GB (2x16GB), DDR4, 3200MHz', '2023-01-22'),
	(225, 'Kingston HyperX Fury 32GB (2x16GB)', 'DDR4 RAM memorija.', 1399.99, 8, 125, 'kingston_hyperx_fury_32gb_2x16gb.jpg', '32GB (2x16GB), DDR4, 3200MHz', '2023-01-23'),
	(226, 'Crucial Ballistix 32GB (2x16GB)', 'DDR4 RAM memorija.', 1299.99, 8, 135, 'crucial_ballistix_32gb_2x16gb.jpg', '32GB (2x16GB), DDR4, 3200MHz', '2023-01-24'),
	(227, 'Corsair Vengeance LPX 64GB (2x32GB)', 'DDR4 RAM memorija.', 2499.99, 8, 145, 'corsair_vengeance_lpx_64gb_2x32gb.jpg', '64GB (2x32GB), DDR4, 3200MHz', '2023-01-25'),
	(228, 'G.Skill Ripjaws V 64GB (2x32GB)', 'DDR4 RAM memorija.', 2599.99, 8, 155, 'gskill_ripjaws_v_64gb_2x32gb.jpg', '64GB (2x32GB), DDR4, 3200MHz', '2023-01-26'),
	(229, 'Kingston HyperX Fury 64GB (2x32GB)', 'DDR4 RAM memorija.', 2499.99, 8, 165, 'kingston_hyperx_fury_64gb_2x32gb.jpg', '64GB (2x32GB), DDR4, 3200MHz', '2023-01-27'),
	(230, 'Crucial Ballistix 64GB (2x32GB)', 'DDR4 RAM memorija.', 2399.99, 8, 175, 'crucial_ballistix_64gb_2x32gb.jpg', '64GB (2x32GB), DDR4, 3200MHz', '2023-01-28'),
	(231, 'ASUS ROG Strix B550-F', 'Matična ploča za AMD procesore.', 899.99, 9, 100, 'asus_rog_strix_b550_f.jpg', 'AM4, ATX, PCIe 4.0', '2023-01-01'),
	(232, 'MSI MPG B550 Gaming Edge WiFi', 'Matična ploča za AMD procesore.', 1099.99, 9, 90, 'msi_mpg_b550_gaming_edge_wifi.jpg', 'AM4, ATX, PCIe 4.0', '2023-01-02'),
	(233, 'Gigabyte B550 AORUS Elite', 'Matična ploča za AMD procesore.', 799.99, 9, 80, 'gigabyte_b550_aorus_elite.jpg', 'AM4, ATX, PCIe 4.0', '2023-01-03'),
	(234, 'ASRock B550 Phantom Gaming 4', 'Matična ploča za AMD procesore.', 699.99, 9, 70, 'asrock_b550_phantom_gaming_4.jpg', 'AM4, ATX, PCIe 4.0', '2023-01-04'),
	(235, 'ASUS TUF Gaming B550-PLUS', 'Matična ploča za AMD procesore.', 899.99, 9, 60, 'asus_tuf_gaming_b550_plus.jpg', 'AM4, ATX, PCIe 4.0', '2023-01-05'),
	(236, 'MSI B450 TOMAHAWK MAX', 'Matična ploča za AMD procesore.', 699.99, 9, 50, 'msi_b450_tomahawk_max.jpg', 'AM4, ATX, PCIe 3.0', '2023-01-06'),
	(237, 'Gigabyte B450 AORUS M', 'Matična ploča za AMD procesore.', 599.99, 9, 40, 'gigabyte_b450_aorus_m.jpg', 'AM4, Micro ATX, PCIe 3.0', '2023-01-07'),
	(238, 'ASRock B450M Pro4', 'Matična ploča za AMD procesore.', 499.99, 9, 30, 'asrock_b450m_pro4.jpg', 'AM4, Micro ATX, PCIe 3.0', '2023-01-08'),
	(239, 'ASUS ROG Strix Z490-E', 'Matična ploča za Intel procesore.', 1299.99, 9, 20, 'asus_rog_strix_z490_e.jpg', 'LGA 1200, ATX, PCIe 4.0', '2023-01-09'),
	(240, 'MSI MPG Z490 Gaming Edge WiFi', 'Matična ploča za Intel procesore.', 1099.99, 9, 10, 'msi_mpg_z490_gaming_edge_wifi.jpg', 'LGA 1200, ATX, PCIe 4.0', '2023-01-10'),
	(241, 'Gigabyte Z490 AORUS Elite', 'Matična ploča za Intel procesore.', 999.99, 9, 5, 'gigabyte_z490_aorus_elite.jpg', 'LGA 1200, ATX, PCIe 4.0', '2023-01-11'),
	(242, 'ASRock Z490 Taichi', 'Matična ploča za Intel procesore.', 1399.99, 9, 15, 'asrock_z490_taichi.jpg', 'LGA 1200, ATX, PCIe 4.0', '2023-01-12'),
	(243, 'ASUS ROG Strix Z590-E', 'Matična ploča za Intel procesore.', 1399.99, 9, 25, 'asus_rog_strix_z590_e.jpg', 'LGA 1200, ATX, PCIe 4.0', '2023-01-13'),
	(244, 'MSI MPG Z590 Gaming Edge WiFi', 'Matična ploča za Intel procesore.', 1199.99, 9, 35, 'msi_mpg_z590_gaming_edge_wifi.jpg', 'LGA 1200, ATX, PCIe 4.0', '2023-01-14'),
	(245, 'Gigabyte Z590 AORUS Master', 'Matična ploča za Intel procesore.', 1999.99, 9, 45, 'gigabyte_z590_aorus_master.jpg', 'LGA 1200, ATX, PCIe 4.0', '2023-01-15'),
	(246, 'ASRock Z590 Taichi', 'Matična ploča za Intel procesore.', 1599.99, 9, 55, 'asrock_z590_taichi.jpg', 'LGA 1200, ATX, PCIe 4.0', '2023-01-16'),
	(247, 'ASUS ROG Strix H470-F', 'Matična ploča za Intel procesore.', 899.99, 9, 65, 'asus_rog_strix_h470_f.jpg', 'LGA 1200, ATX, PCIe 3.0', '2023-01-17'),
	(248, 'MSI H470 Gaming Plus', 'Matična ploča za Intel procesore.', 799.99, 9, 75, 'msi_h470_gaming_plus.jpg', 'LGA 1200, ATX, PCIe 3.0', '2023-01-18'),
	(249, 'Gigabyte H470 AORUS Elite', 'Matična ploča za Intel procesore.', 699.99, 9, 85, 'gigabyte_h470_aorus_elite.jpg', 'LGA 1200, ATX, PCIe 3.0', '2023-01-19'),
	(250, 'ASRock H470 Steel Legend', 'Matična ploča za Intel procesore.', 649.99, 9, 95, 'asrock_h470_steel_legend.jpg', 'LGA 1200, ATX, PCIe 3.0', '2023-01-20'),
	(251, 'ASUS ROG Strix B450-F', 'Matična ploča za AMD procesore.', 799.99, 9, 105, 'asus_rog_strix_b450_f.jpg', 'AM4, ATX, PCIe 3.0', '2023-01-21'),
	(252, 'MSI B450M PRO-VDH MAX', 'Matična ploča za AMD procesore.', 499.99, 9, 115, 'msi_b450m_pro_vdh_max.jpg', 'AM4, Micro ATX, PCIe 3.0', '2023-01-22'),
	(253, 'Gigabyte B450M DS3H', 'Matična ploča za AMD procesore.', 449.99, 9, 125, 'gigabyte_b450m_ds3h.jpg', 'AM4, Micro ATX, PCIe 3.0', '2023-01-23'),
	(254, 'ASRock B450M Pro4', 'Matična ploča za AMD procesore.', 399.99, 9, 135, 'asrock_b450m_pro4.jpg', 'AM4, Micro ATX, PCIe 3.0', '2023-01-24'),
	(255, 'ASUS ROG Strix X570-E', 'Matična ploča za AMD procesore.', 1999.99, 9, 145, 'asus_rog_strix_x570_e.jpg', 'AM4, ATX, PCIe 4.0', '2023-01-25'),
	(256, 'MSI MPG X570 Gaming Edge WiFi', 'Matična ploča za AMD procesore.', 1399.99, 9, 155, 'msi_mpg_x570_gaming_edge_wifi.jpg', 'AM4, ATX, PCIe 4.0', '2023-01-26'),
	(257, 'Gigabyte X570 AORUS Elite', 'Matična ploča za AMD procesore.', 1299.99, 9, 165, 'gigabyte_x570_aorus_elite.jpg', 'AM4, ATX, PCIe 4.0', '2023-01-27'),
	(258, 'ASRock X570 Phantom Gaming 4', 'Matična ploča za AMD procesore.', 999.99, 9, 175, 'asrock_x570_phantom_gaming_4.jpg', 'AM4, ATX, PCIe 4.0', '2023-01-28'),
	(259, 'ASUS TUF Gaming X570-PLUS', 'Matična ploča za AMD procesore.', 1099.99, 9, 185, 'asus_tuf_gaming_x570_plus.jpg', 'AM4, ATX, PCIe 4.0', '2023-01-29'),
	(260, 'Corsair RM750x', '750W napajanje s modularnim kablovima.', 899.99, 10, 100, 'corsair_rm750x.jpg', '750W, 80+ Gold', '2023-01-01'),
	(261, 'Seasonic Focus GX-750', '750W napajanje s visokim performansama.', 899.99, 10, 90, 'seasonic_focus_gx_750.jpg', '750W, 80+ Gold', '2023-01-02'),
	(262, 'EVGA SuperNOVA 750 G5', '750W napajanje s modularnim kablovima.', 849.99, 10, 80, 'evga_supernova_750_g5.jpg', '750W, 80+ Gold', '2023-01-03'),
	(263, 'Thermaltake Toughpower GF1 750W', '750W napajanje s visokom efikasnošću.', 799.99, 10, 70, 'thermaltake_toughpower_gf1_750w.jpg', '750W, 80+ Gold', '2023-01-04'),
	(264, 'Cooler Master MWE Gold 750W', '750W napajanje s modularnim kablovima.', 749.99, 10, 60, 'cooler_master_mwe_gold_750w.jpg', '750W, 80+ Gold', '2023-01-05'),
	(265, 'be quiet! Straight Power 11 750W', '750W napajanje s tišim radom.', 899.99, 10, 50, 'be_quiet_straight_power_11_750w.jpg', '750W, 80+ Gold', '2023-01-06'),
	(266, 'Corsair CV550', '550W napajanje za osnovne potrebe.', 499.99, 10, 40, 'corsair_cv550.jpg', '550W, 80+ Bronze', '2023-01-07'),
	(267, 'Thermaltake Smart 500W', '500W napajanje za osnovne potrebe.', 399.99, 10, 30, 'thermaltake_smart_500w.jpg', '500W, 80+ Bronze', '2023-01-08'),
	(268, 'EVGA 600 W1', '600W napajanje s osnovnim performansama.', 499.99, 10, 20, 'evga_600_w1.jpg', '600W, 80+ Bronze', '2023-01-09'),
	(269, 'Seasonic S12III 500W', '500W napajanje s visokom efikasnošću.', 499.99, 10, 10, 'seasonic_s12iii_500w.jpg', '500W, 80+ Bronze', '2023-01-10'),
	(270, 'Cooler Master MWE Bronze 650W', '650W napajanje s modularnim kablovima.', 599.99, 10, 5, 'cooler_master_mwe_bronze_650w.jpg', '650W, 80+ Bronze', '2023-01-11'),
	(271, 'Corsair TX650M', '650W napajanje s polu-modularnim kablovima.', 799.99, 10, 15, 'corsair_tx650m.jpg', '650W, 80+ Gold', '2023-01-12'),
	(272, 'be quiet! Pure Power 11 600W', '600W napajanje s tišim radom.', 699.99, 10, 25, 'be_quiet_pure_power_11_600w.jpg', '600W, 80+ Gold', '2023-01-13'),
	(273, 'Antec Earthwatts Gold Pro 650W', '650W napajanje s visokom efikasnošću.', 749.99, 10, 35, 'antec_earthwatts_gold_pro_650w.jpg', '650W, 80+ Gold', '2023-01-14'),
	(274, 'FSP Hydro G 750W', '750W napajanje s visokom efikasnošću.', 849.99, 10, 45, 'fsp_hydro_g_750w.jpg', '750W, 80+ Gold', '2023-01-15'),
	(275, 'XPG Core Reactor 750W', '750W napaj anje s modularnim kablovima.', 899.99, 10, 55, 'xpg_core_reactor_750w.jpg', '750W, 80+ Gold', '2023-01-16'),
	(276, 'Cooler Master V750 Gold', '750W napajanje s visokom efikasnošću.', 899.99, 10, 65, 'cooler_master_v750_gold.jpg', '750W, 80+ Gold', '2023-01-17'),
	(277, 'Thermaltake Toughpower PF1 850W', '850W napajanje s visokom efikasnošću.', 999.99, 10, 75, 'thermaltake_toughpower_pf1_850w.jpg', '850W, 80+ Platinum', '2023-01-18'),
	(278, 'Seasonic Focus GX-850', '850W napajanje s modularnim kablovima.', 999.99, 10, 85, 'seasonic_focus_gx_850.jpg', '850W, 80+ Gold', '2023-01-19'),
	(279, 'EVGA SuperNOVA 850 G5', '850W napajanje s visokom efikasnošću.', 949.99, 10, 95, 'evga_supernova_850_g5.jpg', '850W, 80+ Gold', '2023-01-20'),
	(280, 'Corsair RM850x', '850W napajanje s modularnim kablovima.', 999.99, 10, 100, 'corsair_rm850x.jpg', '850W, 80+ Gold', '2023-01-20'),
	(281, 'be quiet! Dark Power Pro 12 850W', '850W napajanje s tišim radom.', 1099.99, 10, 105, 'be_quiet_dark_power_pro_12_850w.jpg', '850W, 80+ Platinum', '2023-01-22'),
	(282, 'Antec HCG-850M', '850W napajanje s polu-modularnim kablovima.', 899.99, 10, 110, 'antec_hcg_850m.jpg', '850W, 80+ Gold', '2023-01-23'),
	(283, 'FSP Hydro G 850W', '850W napajanje s visokom efikasnošću.', 899.99, 10, 115, 'fsp_hydro_g_850w.jpg', '850W, 80+ Gold', '2023-01-24'),
	(284, 'Thermaltake Toughpower GF1 850W', '850W napajanje s visokom efikasnošću.', 999.99, 10, 120, 'thermaltake_toughpower_gf1_850w.jpg', '850W, 80+ Gold', '2023-01-25'),
	(285, 'Cooler Master MWE Gold 850W', '850W napajanje s modularnim kablovima.', 899.99, 10, 125, 'cooler_master_mwe_gold_850w.jpg', '850W, 80+ Gold', '2023-01-26'),
	(286, 'Seasonic Focus GX-1000', '1000W napajanje s modularnim kablovima.', 1099.99, 10, 130, 'seasonic_focus_gx_1000.jpg', '1000W, 80+ Gold', '2023-01-27'),
	(287, 'Corsair RM1000x', '1000W napajanje s modularnim kablovima.', 1099.99, 10, 135, 'corsair_rm1000x.jpg', '1000W, 80+ Gold', '2023-01-28'),
	(288, 'EVGA SuperNOVA 1000 G5', '1000W napajanje s visokom efikasnošću.', 1099.99, 10, 140, 'evga_supernova_1000_g5.jpg', '1000W, 80+ Gold', '2023-01-29'),
	(289, 'be quiet! Dark Power Pro 12 1000W', '1000W napajanje s tišim radom.', 1299.99, 10, 145, 'be_quiet_dark_power_pro_12_1000w.jpg', '1000W, 80+ Platinum', '2023-01-30'),
	(290, 'Cooler Master Hyper 212 EVO', 'Hladnjak za procesor s odličnim hlađenjem.', 499.99, 11, 100, 'cooler_master_hyper_212_evo.jpg', '120mm, zrak', '2023-01-01'),
	(291, 'Noctua NH-D15', 'Premium zračni hladnjak za procesor.', 1499.99, 11, 90, 'noctua_nh_d15.jpg', '140mm, zrak', '2023-01-02'),
	(292, 'be quiet! Dark Rock Pro 4', 'Tih zračni hladnjak za procesor.', 1299.99, 11, 80, 'be_quiet_dark_rock_pro_4.jpg', '120mm + 140mm, zrak', '2023-01-03'),
	(293, 'Corsair H100i RGB Platinum', 'AIO vodeni hladnjak s RGB osvjetljenjem.', 1299.99, 11, 70, 'corsair_h100i_rgb_platinum.jpg', '240mm, voda', '2023-01-04'),
	(294, 'NZXT Kraken X63', 'AIO vodeni hladnjak s RGB osvjetljenjem.', 1399.99, 11, 60, 'nzxt_kraken_x63.jpg', '280mm, voda', '2023-01-05'),
	(295, 'Thermalright Macho Rev.B', 'Zračni hladnjak za procesor.', 699.99, 11, 50, 'thermalright_macho_rev_b.jpg', '140mm, zrak', '2023-01-06'),
	(296, 'Arctic Freezer 34 eSports DUO', 'Zračni hladnjak s dvostrukim ventilatorima.', 799.99, 11, 40, 'arctic_freezer_34_esports_duo.jpg', '120mm, zrak', '2023-01-07'),
	(297, 'Deepcool Gammaxx 400', 'Zračni hladnjak za procesor.', 399.99, 11, 30, 'deepcool_gammaxx_400.jpg', '120mm, zrak', '2023-01-08'),
	(298, 'Cooler Master MasterLiquid ML240L', 'AIO vodeni hladnjak.', 799.99, 11, 20, 'cooler_master_masterliquid_ml240l.jpg', '240mm, voda', '2023-01-09'),
	(299, 'Thermaltake Water 3.0 240 ARGB', 'AIO vodeni hladnjak s RGB osvjetljenjem.', 999.99, 11, 10, 'thermaltake_water_3_0_240_argb.jpg', '240mm, voda', '2023-01-10'),
	(300, 'Cryorig H7', 'Zračni hladnjak za procesor.', 599.99, 11, 5, 'cryorig_h7.jpg', '120mm, zrak', '2023-01-11'),
	(301, 'Scythe Mugen 5 Rev.B', 'Zračni hladnjak za procesor.', 699.99, 11, 15, 'scythe_mugen_5_rev_b.jpg', '120mm, zrak', '2023-01-12'),
	(302, 'Cooler Master MasterAir MA620P', 'Zračni hladnjak s RGB osvjetljenjem.', 899.99, 11, 25, 'cooler_master_masterair_ma620p.jpg', '120mm + 120mm, zrak', '2023-01-13'),
	(303, 'Noctua NH-U12S Redux', 'Zračni hladnjak za procesor.', 699.99, 11, 35, 'noctua_nh_u12s_redux.jpg', '120mm, zrak', '2023-01-14'),
	(304, 'ARCTIC Freezer 50 TR', 'Zračni hladnjak za procesor.', 999.99, 11, 45, 'arctic_freezer_50_tr.jpg', '120mm + 140mm, zrak', '2023-01-15'),
	(305, 'be quiet! Pure Rock 2', 'Zračni hladnjak za procesor.', 499.99, 11, 55, 'be_quiet_pure_rock_2.jpg', '120 mm, zrak', '2023-01-16'),
	(306, 'Thermalright Peerless Assassin', 'Zračni hladnjak za procesor.', 799.99, 11, 65, 'thermalright_peerless_assassin.jpg', '120mm + 120mm, zrak', '2023-01-17'),
	(307, 'Cooler Master MasterLiquid ML120L', 'AIO vodeni hladnjak.', 699.99, 11, 75, 'cooler_master_masterliquid_ml120l.jpg', '120mm, voda', '2023-01-18'),
	(308, 'Deepcool Gammaxx 400 V2', 'Zračni hladnjak za procesor.', 449.99, 11, 85, 'deepcool_gammaxx_400_v2.jpg', '120mm, zrak', '2023-01-19'),
	(309, 'ARCTIC Freezer 34 eSports', 'Zračni hladnjak s dvostrukim ventilatorima.', 799.99, 11, 95, 'arctic_freezer_34_esports.jpg', '120mm, zrak', '2023-01-20'),
	(310, 'Noctua NH-L12S', 'Zračni hladnjak za procesor.', 599.99, 11, 105, 'noctua_nh_l12s.jpg', '120mm, zrak', '2023-01-21'),
	(311, 'Thermalright ARO-M14', 'Zračni hladnjak za procesor.', 499.99, 11, 115, 'thermalright_aro_m14.jpg', '140mm, zrak', '2023-01-22'),
	(312, 'Cooler Master Hyper 212 Black Edition', 'Hladnjak za procesor s odličnim hlađenjem.', 499.99, 11, 125, 'cooler_master_hyper_212_black_edition.jpg', '120mm, zrak', '2023-01-23'),
	(313, 'be quiet! Shadow Rock 3', 'Zračni hladnjak za procesor.', 799.99, 11, 135, 'be_quiet_shadow_rock_3.jpg', '120mm, zrak', '2023-01-24'),
	(314, 'ARCTIC Freezer 34 eSports DUO RGB', 'Zračni hladnjak s RGB osvjetljenjem.', 899.99, 11, 145, 'arctic_freezer_34_esports_duo_rgb.jpg', '120mm, zrak', '2023-01-25'),
	(315, 'Cooler Master MasterAir MA410M', 'Zračni hladnjak s RGB osvjetljenjem.', 899.99, 11, 155, 'cooler_master_masterair_ma410m.jpg', '120mm + 120mm, zrak', '2023-01-26'),
	(316, 'Thermalright ARO-M14 Plus', 'Zračni hladnjak za procesor.', 599.99, 11, 165, 'thermalright_aro_m14_plus.jpg', '140mm, zrak', '2023-01-27'),
	(317, 'Noctua NH-U14S', 'Zračni hladnjak za procesor.', 799.99, 11, 175, 'noctua_nh_u14s.jpg', '140mm, zrak', '2023-01-28'),
	(318, 'be quiet! Dark Rock 4', 'Zračni hladnjak za procesor.', 999.99, 11, 185, 'be_quiet_dark_rock_4.jpg', '120mm + 140mm, zrak', '2023-01-29'),
	(319, 'Corsair H115i RGB Platinum', 'AIO vodeni hladnjak s RGB osvjetljenjem.', 1399.99, 11, 195, 'corsair_h115i_rgb_platinum.jpg', '280mm, voda', '2023-01-30'),
	(320, 'NZXT H510', 'Mid Tower kućište s modernim dizajnom.', 699.99, 12, 100, 'nzxt_h510.jpg', 'ATX, tempered glass', '2023-01-01'),
	(321, 'Corsair 4000D Airflow', 'Mid Tower kućište s odličnom ventilacijom.', 799.99, 12, 90, 'corsair_4000d_airflow.jpg', 'ATX, tempered glass', '2023-01-02'),
	(322, 'Fractal Design Meshify C', 'Mid Tower kućište s odličnom ventilacijom.', 899.99, 12, 80, 'fractal_design_meshify_c.jpg', 'ATX, mesh', '2023-01-03'),
	(323, 'Cooler Master MasterBox Q300L', 'Kompakt kućište s odličnom ventilacijom.', 499.99, 12, 70, 'cooler_master_masterbox_q300l.jpg', 'Micro ATX, mesh', '2023-01-04'),
	(324, 'Thermaltake V200', 'Mid Tower kućište s RGB osvjetljenjem.', 799.99, 12, 60, 'thermaltake_v200.jpg', 'ATX, tempered glass', '2023-01-05'),
	(325, 'be quiet! Pure Base 500', 'Mid Tower kućište s tišim radom.', 699.99, 12, 50, 'be_quiet_pure_base_500.jpg', 'ATX, tempered glass', '2023-01-06'),
	(326, 'Lian Li PC-O11 Dynamic', 'Mid Tower kućište s odličnom ventilacijom.', 1099.99, 12, 40, 'lian_li_pc_o11_dynamic.jpg', 'ATX, tempered glass', '2023-01-07'),
	(327, 'Corsair 275R Airflow', 'Mid Tower kućište s odličnom ventilacijom.', 699.99, 12, 30, 'corsair_275r_airflow.jpg', 'ATX, tempered glass', '2023-01-08'),
	(328, 'Phanteks Eclipse P400A', 'Mid Tower kućište s odličnom ventilacijom.', 799.99, 12, 20, 'phanteks_eclipse_p400a.jpg', 'ATX, mesh', '2023-01-09'),
	(329, 'Cooler Master HAF 912', 'Mid Tower kućište s odličnom ventilacijom.', 599.99, 12, 10, 'cooler_master_haf_912.jpg', 'ATX, mesh', '2023-01-10'),
	(330, 'Thermaltake S500', 'Mid Tower kućište s modernim dizajnom.', 699.99, 12, 5, 'thermaltake_s500.jpg', 'ATX, tempered glass', '2023-01-11'),
	(331, 'Fractal Design Define R5', 'Mid Tower kućište s odličnom izolacijom.', 899.99, 12, 15, 'fractal_design_define_r5.jpg', 'ATX, soundproof', '2023-01-12'),
	(332, 'NZXT H510i', 'Mid Tower kućište s RGB osvjetljenjem.', 799.99, 12, 25, 'nzxt_h510i.jpg', 'ATX, tempered glass', '2023-01-13'),
	(333, 'Corsair Crystal 280X', 'Kompakt kućište s RGB osvjetljenjem.', 899.99, 12, 35, 'corsair_crystal_280x.jpg', 'Micro ATX, tempered glass', '2023-01-14'),
	(334, 'Cooler Master MasterBox MB511', 'Mid Tower kućište s odličnom ventilacijom.', 699.99, 12, 45, 'cooler_master_masterbox_mb511.jpg', 'ATX, mesh', '2023-01-15'),
	(335, 'Thermaltake View 71', 'Full Tower kućište s RGB osvjetljenjem.', 1399.99, 12, 55, 'thermaltake_view_71.jpg', 'E-ATX, tempered glass', '2023-01-16'),
	(336, 'be quiet! Dark Base 700', 'Full Tower kućište s odličnom izolacijom.', 1399.99, 12, 65, 'be_quiet_dark_base_700.jpg', 'E-ATX, soundproof', '2023-01-17'),
	(337, 'Lian Li PC-011 Air', 'Full Tower kućište s odličnom ventilacijom.', 1299.99, 12, 75, 'lian_li_pc_011_air.jpg', 'E-ATX, tempered glass', '2023-01-18'),
	(338, 'Corsair 1000D', 'Super Tower kućište s RGB osvjetljenjem.', 2499.99, 12, 85, 'corsair_1000d.jpg', 'E-ATX, tempered glass', '2023-01-19'),
	(339, 'Phanteks Enthoo Elite', 'Super Tower kućište s odličnom ventilacijom.', 1999.99, 12, 95, 'phanteks_enthoo_elite.jpg', 'E-ATX, tempered glass', '2023-01-20'),
	(340, 'Cooler Master MasterBox Q300P', 'Kompakt kućište s odličnom ventilacijom.', 599.99, 12, 105, 'cooler_master_masterbox_q300p.jpg', 'Micro ATX, mesh', '2023-01-21'),
	(341, 'Thermaltake Core P3', 'Open Frame kućište s modernim dizajnom.', 899.99, 12, 115, 'thermaltake_core_p3.jpg', 'ATX, open frame', '2023-01-22'),
	(342, 'Fractal Design Meshify S2', 'Full Tower kućište s odličnom ventilacijom.', 1399.99, 12, 125, 'fractal_design_meshify_s2.jpg', 'E-ATX, mesh', '2023-01-23'),
	(343, 'NZXT H510 Elite', 'Mid Tower kućište s RGB osvjetljenjem.', 1099.99, 12, 135, 'nzxt_h510_elite.jpg', 'ATX, tempered glass', '2023-01-24'),
	(344, 'Corsair 220T RGB', 'Mid Tower kućište s RGB osvjetljenjem.', 799.99, 12, 145, 'corsair_220t_rgb.jpg', 'ATX, tempered glass', '2023-01-25'),
	(345, 'Cooler Master MasterBox MB320L', 'Kompakt kućište s odličnom ventilacijom.', 499.99, 12, 155, 'cooler_master_masterbox_mb320l.jpg', 'Micro ATX, mesh', '2023-01-26'),
	(346, 'Thermaltake Versa H21', 'Mid Tower kućište s modernim dizajnom.', 499.99, 12, 165, 'thermaltake_versa_h21.jpg', 'ATX, tempered glass', '2023-01-27'),
	(347, 'be quiet! Pure Base 600', 'Mid Tower kućište s tišim radom.', 699.99, 12, 175, 'be_quiet_pure_base_600.jpg', 'ATX, soundproof', '2023-01-28'),
	(348, 'Lian Li PC-O11 Air', 'Mid Tower kućište s odličnom ventilacijom.', 1099.99, 12, 185, 'lian_li_pc_o11_air.jpg', 'ATX, tempered glass', '2023-01-29'),
	(349, 'Microsoft Office 2021', 'Office paket za produktivnost.', 1499.99, 14, 100, 'microsoft_office_2021.jpg', 'Word, Excel, PowerPoint', '2023-01-01'),
	(350, 'Adobe Photoshop 2023', 'Softver za obradu slika.', 2999.99, 14, 90, 'adobe_photoshop_2023.jpg', 'Grafička obrada', '2023-01-02'),
	(351, 'Autodesk AutoCAD 2023', 'Softver za CAD dizajn.', 4999.99, 14, 80, 'autodesk_autocad_2023.jpg', '2D i 3D dizajn', '2023-01-03'),
	(352, 'Norton Antivirus 2023', 'Antivirusni softver za zaštitu.', 799.99, 14, 70, 'norton_antivirus_2023.jpg', 'Zaštita od virusa', '2023-01-04'),
	(353, 'Microsoft Windows 11', 'Operativni sustav za računala.', 1999.99, 14, 60, 'microsoft_windows_11.jpg', 'Najnovija verzija Windowsa', '2023-01-05'),
	(354, 'CorelDRAW Graphics Suite 2023', 'Softver za grafički dizajn.', 2499.99, 14, 50, 'coreldraw_graphics_suite_2023.jpg', 'Vektorska grafika', '2023-01-06'),
	(355, 'Adobe Premiere Pro 2023', 'Softver za video montažu.', 2999.99, 14, 40, 'adobe_premiere_pro_2023.jpg', 'Video obrada', '2023-01-07'),
	(356, 'Zoom Video Communications', 'Softver za videokonferencije.', 499.99, 14, 30, 'zoom_video_communications.jpg', 'Videopozivi', '2023-01-08'),
	(357, 'Slack', 'Softver za timsku komunikaciju.', 299.99, 14, 20, 'slack.jpg', 'Timska suradnja', '2023-01-09'),
	(358, 'WinRAR', 'Softver za kompresiju datoteka.', 299.99, 14, 10, 'winrar.jpg', 'Kompresija i dekompresija', '2023-01-10'),
	(359, 'Adobe Illustrator 2023', 'Softver za vektorsku grafiku.', 2999.99, 14, 5, 'adobe_illustrator_2023.jpg', 'Vektorska grafika', '2023-01-11'),
	(360, 'Microsoft Visio 2021', 'Softver za dijagrame i vizualizacije.', 1499.99, 14, 15, 'microsoft_visio_2021.jpg', 'Dijagrami', '2023-01-12'),
	(361, 'Kaspersky Internet Security 2023', 'Antivirusni softver s dodatnim zaštitama.', 899.99, 14, 25, 'kaspersky_internet_security_2023.jpg', 'Zaštita od prijetnji', '2023-01-13'),
	(362, 'VMware Workstation Pro 16', 'Softver za virtualizaciju.', 2499.99, 14, 35, 'vmware_workstation_pro_16.jpg', 'Virtualizacija', '2023-01-14'),
	(363, 'Adobe After Effects 2023', 'Softver za video efekte.', 2999.99, 14, 45, 'adobe_after_effects_2023.jpg', 'Video efekti', '2023-01-15'),
	(364, 'Microsoft OneNote', 'Softver za bilješke.', 499.99, 14, 55, 'microsoft_onenote.jpg', 'Bilješke i organizacija', '2023-01-16'),
	(365, 'Final Cut Pro X', 'Softver za video montažu na Macu.', 2999.99, 14, 65, 'final_cut_pro_x.jpg', 'Video obrada', '2023-01-17'),
	(366, 'Sublime Text 4', 'Tekstualni editor za programere.', 199.99, 14, 85, 'sublime_text_4.jpg', 'Editor za kodiranje', '2023-01-19'),
	(367, 'Notepad++', 'Tekstualni editor.', 1.0, 14, 95, 'notepad++.jpg', 'Editor za kodiranje', '2023-01-20'),
	(368, 'Microsoft Project 2021', 'Softver za upravljanje projektima.', 1999.99, 14, 105, 'microsoft_project_2021.jpg', 'Upravljanje projektima', '2023-01-21'),
	(369, 'Adobe InDesign 2023', 'Softver za dizajn i publikaciju.', 2999.99, 14, 115, 'adobe_indesign_2023.jpg', 'Dizajn i publikacija', '2023-01-22'),
	(370, 'Corel Painter 2023', 'Softver za digitalno slikanje.', 2499.99, 14, 125, 'corel_painter_2023.jpg', 'Digitalno slikanje', '2023-01-23'),
	(371, 'Microsoft Access 2021', 'Softver za upravljanje bazama podataka.', 1499.99, 14, 135, 'microsoft_access_2021.jpg', 'Upravljanje bazama podataka', '2023-01-24'),
	(372, 'Adobe Lightroom 2023', 'Softver za obradu fotografija.', 1999.99, 14, 145, 'adobe_lightroom_2023.jpg', 'Obrada fotografija', '2023-01-25'),
	(373, 'CyberLink PowerDirector 20', 'Softver za video montažu.', 1999.99, 14, 155, 'cyberlink_powerdirector_20.jpg', 'Video obrada', '2023-01-26'),
	(374, 'Microsoft Publisher 2021', 'Softver za dizajn publikacija.', 1499.99, 14, 165, 'microsoft_publisher_2021.jpg', 'Dizajn publikacija', '2023-01-27'),
	(375, 'Corel VideoStudio 2023', 'Softver za video montažu.', 1999.99, 14, 175, 'corel_videostudio_2023.jpg', 'Video obrada', '2023-01-28'),
	(376, 'Adobe XD 2023', 'Softver za dizajn korisničkog sučelja.', 1999.99, 14, 185, 'adobe_xd_2023.jpg', 'Dizajn korisničkog sučelja', '2023-01-29'),
	(377, 'Microsoft Teams', 'Softver za timsku suradnju.', 10.00, 14, 195, 'microsoft_teams.jpg', 'Timska suradnja', '2023-01-30'),
	(378, 'TP-Link Archer AX6000', 'Wi-Fi 6 usmjerivač.', 1999.99, 15, 100, 'tp_link_archer_ax6000.jpg', 'Wi-Fi 6, 6000 Mbps', '2023-01-01'),
	(379, 'Netgear Nighthawk AX12', 'Wi-Fi 6 usmjerivač.', 2499.99, 15, 90, 'netgear_nighthawk_ax12.jpg', 'Wi-Fi 6, 12000 Mbps', '2023-01-02'),
	(380, 'ASUS RT-AX88U', 'Wi-Fi 6 usmjerivač.', 1999.99, 15, 80, 'asus_rt_ax88u.jpg', 'Wi-Fi 6, 6000 Mbps', '2023-01-03'),
	(381, 'Linksys EA9500', 'Tri-band usmjerivač.', 1799.99, 15, 70, 'linksys_ea9500.jpg', 'Tri-band, 5000 Mbps', '2023-01-04'),
	(382, 'TP-Link Deco X60', 'Wi-Fi 6 mesh sustav.', 2499.99, 15, 60, 'tp_link_deco_x60.jpg', 'Wi-Fi 6, 3000 Mbps', '2023-01-05'),
	(383, 'Netgear Orbi RBK852', 'Wi-Fi 6 mesh sustav.', 2999.99, 15, 50, 'netgear_orbi_rbk852.jpg', 'Wi-Fi 6, 6000 Mbps', '2023-01-06'),
	(384, 'ASUS ZenWiFi AX6600', 'Wi-Fi 6 mesh sustav.', 2499.99, 15, 40, 'asus_zenwifi_ax6600.jpg', 'Wi-Fi 6, 6600 Mbps', '2023-01-07'),
	(385, 'TP-Link Archer AX50', 'Wi-Fi 6 usmjerivač.', 1299.99, 15, 30, 'tp_link_archer_ax50.jpg', 'Wi-Fi 6, 3000 Mbps', '2023-01-08'),
	(386, 'Netgear Nighthawk RAX40', 'Wi-Fi 6 usmjerivač.', 1499.99, 15, 20, 'netgear_nighthawk_rax40.jpg', 'Wi-Fi 6, 3000 Mbps', '2023-01-09'),
	(387, 'Linksys MR7350', 'Wi-Fi 6 usmjerivač.', 999.99, 15, 10, 'linksys_mr7350.jpg', 'Wi-Fi 6, 1800 Mbps', '2023-01-10'),
	(388, 'TP-Link Archer A7', 'Dual-band usmjerivač.', 499.99, 15, 5, 'tp_link_archer_a7.jpg', 'Dual-band, 1750 Mbps', '2023-01-11'),
	(389, 'ASUS RT-AC66U B1', 'Dual-band usmjerivač.', 699.99, 15, 15, 'asus_rt_ac66u_b1.jpg', 'Dual-band, 1750 Mbps', '2023-01-12'),
	(390, 'Netgear R6700', 'Dual-band usmjerivač.', 599.99, 15, 25, 'netgear_r6700.jpg', 'Dual-band, 1750 Mbps', '2023-01-13'),
	(391, 'TP-Link TL-WR841N', 'N300 usmjerivač.', 299.99, 15, 35, 'tp_link_tl_wr841n.jpg', '300 Mbps', '2023-01-14'),
	(392, 'D-Link DIR-615', 'N150 usmjerivač.', 199.99, 15, 45, 'd_link_dir_615.jpg', '150 Mbps', '2023-01-15'),
	(393, 'TP-Link TL-SG108', '8-portni gigabitni switch.', 499.99, 15, 55, 'tp_link_tl_sg108.jpg', '8-portni, gigabit', '2023-01-16'),
	(394, 'Netgear GS308', '8-portni gigabitni switch.', 399.99, 15, 65, 'netgear_gs308.jpg', '8-portni, gigabit', '2023-01-17'),
	(395, 'TP-Link TL-SG1016D', '16-portni gigabitni switch.', 799.99, 15, 75, 'tp_link_tl_sg1016d.jpg', '16-portni, gigabit', '2023-01-18'),
	(396, 'D-Link DGS-1016D', '16-portni gigabitni switch.', 699.99, 15, 85, 'd_link_dgs_1016d.jpg', '16-portni, gigabit', '2023-01-19'),
	(397, 'TP-Link TL-SG108E', '8-portni smart switch.', 599.99, 15, 95, 'tp_link_tl_sg108e.jpg', '8-portni, gigabit', '2023-01-20'),
	(398, 'Netgear GS310TP', '8-portni PoE switch.', 999.99, 15, 105, 'netgear_gs310tp.jpg', '8-portni, gigabit, PoE', '2023-01-21'),
	(399, 'TP-Link TL-SG2210P', '10-portni PoE switch.', 1299.99, 15, 115, 'tp_link_tl_sg2210p.jpg', '10-portni, gigabit, PoE', '2023-01-22'),
	(400, 'D-Link DGS-1210-10P', '10-portni PoE switch.', 1199.99, 15, 125, 'd_link_dgs_1210_10p.jpg', '10-portni, gigabit, PoE', '2023-01-23'),
	(401, 'TP-Link TL-SG2424P', ' 24-portni PoE switch.', 1999.99, 15, 135, 'tp_link_tl_sg2424p.jpg', '24-portni, gigabit, PoE', '2023-01-24'),
	(402, 'Netgear GS724TP', '24-portni PoE switch.', 1799.99, 15, 145, 'netgear_gs724tp.jpg', '24-portni, gigabit, PoE', '2023-01-25'),
	(403, 'TP-Link TL-SG3210XHP', '10-portni PoE switch.', 2499.99, 15, 155, 'tp_link_tl_sg3210xhp.jpg', '10-portni, gigabit, PoE', '2023-01-26'),
	(404, 'D-Link DGS-1210-24P', '24-portni PoE switch.', 1999.99, 15, 165, 'd_link_dgs_1210_24p.jpg', '24-portni, gigabit, PoE', '2023-01-27'),
	(405, 'TP-Link TL-SG108E', '8-portni smart switch.', 599.99, 15, 175, 'tp_link_tl_sg108e.jpg', '8-portni, gigabit', '2023-01-28'),
	(406, 'Netgear GS308E', '8-portni smart switch.', 499.99, 15, 185, 'netgear_gs308e.jpg', '8-portni, gigabit', '2023-01-29'),
	(407, 'TP-Link TL-SG1016D', '16-portni gigabitni switch.', 799.99, 15, 195, 'tp_link_tl_sg1016d.jpg', '16-portni, gigabit', '2023-01-30'),
	(408, 'Sony PlayStation 5', 'Najnovija igraća konzola od Sony-a.', 4999.99, 16, 100, 'sony_playstation_5.jpg', '4K, 120fps', '2023-01-01'),
	(409, 'Microsoft Xbox Series X', 'Najnovija igraća konzola od Microsoft-a.', 4999.99, 16, 90, 'microsoft_xbox_series_x.jpg', '4K, 120fps', '2023-01-02'),
	(410, 'Nintendo Switch', 'Hibridna igraća konzola.', 2999.99, 16, 80, 'nintendo_switch.jpg', '720p/1080p', '2023-01-03'),
	(411, 'Sony PlayStation 4 Pro', 'Igraća konzola s poboljšanim performansama.', 2999.99, 16, 70, 'sony_playstation_4_pro.jpg', '4K, 60fps', '2023-01-04'),
	(412, 'Microsoft Xbox One X', 'Igraća konzola s poboljšanim performansama.', 2499.99, 16, 60, 'microsoft_xbox_one_x.jpg', '4K, 60fps', '2023-01-05'),
	(413, 'Nintendo Switch Lite', 'Kompakt verzija Nintendo Switch-a.', 1999.99, 16, 50, 'nintendo_switch_lite.jpg', '720p', '2023-01-06'),
	(414, 'Sony PlayStation 4 Slim', 'Tanji model PlayStation 4.', 1999.99, 16, 40, 'sony_playstation_4_slim.jpg', '1080p', '2023-01-07'),
	(415, 'Microsoft Xbox One S', 'Tanji model Xbox One.', 1799.99, 16, 30, 'microsoft_xbox_one_s.jpg', '1080p', '2023-01-08'),
	(416, 'Sega Genesis Mini', 'Mini verzija klasične konzole.', 499.99, 16, 20, 'sega_genesis_mini.jpg', '720p', '2023-01-09'),
	(417, 'Atari Flashback 8', 'Klasik igraća konzola.', 399.99, 16, 10, 'atari_flashback_8.jpg', '720p', '2023-01-10'),
	(418, 'Sony PlayStation Classic', 'Mini verzija PlayStation konzole.', 499.99, 16, 5, 'sony_playstation_classic.jpg', '720p', '2023-01-11'),
	(419, 'Nintendo Classic Mini', 'Mini verzija Nintendo konzole.', 399.99, 16, 15, 'nintendo_classic_mini.jpg', '720p', '2023-01-12'),
	(420, 'Sega Mega Drive Mini', 'Mini verzija Sega Mega Drive konzole.', 499.99, 16, 25, 'sega_mega_drive_mini.jpg', '720p', '2023-01-13'),
	(421, 'Microsoft Xbox Series S', 'Kompakt verzija Xbox Series X.', 2999.99, 16, 35, 'microsoft_xbox_series_s.jpg', '1440p, 120fps', '2023-01-14'),
	(422, 'Sony PlayStation VR', 'VR headset za PlayStation konzole.', 1999.99, 16, 45, 'sony_playstation_vr.jpg', 'VR, 1080p', '2023-01-15'),
	(423, 'Oculus Quest 2', 'Bežični VR headset.', 2999.99, 16, 55, 'oculus_quest_2.jpg', 'VR, 1832x1920', '2023-01-16'),
	(424, 'Valve Steam Deck', 'Handheld gaming konzola.', 3999.99, 16, 65, 'valve_steam_deck.jpg', '720p, 60fps', '2023-01-17'),
	(425, 'Razer Kishi', 'Mobilni gaming kontroler.', 699.99, 16, 75, 'razer_kishi.jpg', 'Za mobilne uređaje', '2023-01-18'),
	(426, 'Logitech G Cloud', 'Handheld gaming konzola.', 2999.99, 16, 85, 'logitech_g_cloud.jpg', '720p, 60fps', '2023-01-19'),
	(427, 'Nintendo Switch OLED', 'Poboljšana verzija Nintendo Switch-a.', 3499.99, 16, 95, 'nintendo_switch_oled.jpg', '720p/1080p', '2023-01-20'),
	(428, 'Sony PlayStation 5 Digital Edition', 'Digitalna verzija PlayStation 5.', 4999.99, 16, 105, 'sony_playstation_5_digital.jpg', '4K, 120fps', '2023-01-21'),
	(429, 'Microsoft Xbox Series X Halo Infinite Edition', 'Specijalna verzija Xbox Series X.', 5999.99, 16, 115, 'microsoft_xbox_series_x_halo_infinite.jpg', '4K, 120fps', '2023-01-22'),
	(430, 'Nintendo Switch Pro', 'Novi model Nintendo Switch-a.', 3999.99, 16, 125, 'nintendo_switch_pro.jpg', '720p/1080p', '2023-01-23'),
	(431, 'Sony PlayStation 4 Pro 1TB', 'Igraća konzola s 1TB memorije.', 2999.99, 16, 135, 'sony_playstation_4_pro_1tb.jpg', '4K, 60fps', '2023-01-24'),
	(432, 'Microsoft Xbox One X 1TB', 'Igraća konzola s 1TB memorije.', 2499.99, 16, 145, 'microsoft_xbox_one_x_1tb.jpg', '4K, 60fps', '2023-01-25'),
	(433, 'Sega Mega Drive', 'Klasična igraća konzola.', 499.99, 16, 155, 'sega_mega_drive.jpg', '720p', '2023-01-26'),
	(434, 'Atari 2600', 'Klasična igraća konzola.', 399.99, 16, 165, 'atari_2600.jpg', '720p', '2023-01-27'),
	(435, 'Sony PlayStation 3', 'Igraća konzola s odličnim igrama.', 1999.99, 16, 175, 'sony_playstation_3.jpg', '1080p', '2023-01-28'),
	(436, 'Microsoft Xbox 360', 'Igraća konzola s odličnim igrama.', 1999.99, 16, 185, 'microsoft_xbox_360.jpg', '1080p', '2023-01-29'),
	(437, 'Nintendo Wii', 'Igraća konzola s inovativnim kontrolerima.', 1499.99, 16, 195, 'nintendo_wii.jpg', '480p', '2023-01-30'),
	(438, 'Samsung T7 Portable SSD 1TB', 'Brzi prijenosni SSD.', 899.99, 17, 100, 'samsung_t7_portable_ssd_1tb.jpg', '1TB, USB 3.2', '2023-01-01'),
	(439, 'SanDisk Extreme Portable SSD 1TB', 'Izdržljiv prijenosni SSD.', 999.99, 17, 90, 'sandisk_extreme_portable_ssd_1tb.jpg', '1TB, USB 3.1', '2023-01-02'),
	(440, 'WD My Passport 2TB', 'Prijenosni HDD s velikim kapacitetom.', 499.99, 17, 80, 'wd_my_passport_2tb.jpg', '2TB, USB 3.0', '2023-01-03'),
	(441, 'Seagate Backup Plus Slim 2TB', 'Prijenosni HDD s brzim prijenosom.', 599.99, 17, 70, 'seagate_backup_plus_slim_2tb.jpg', '2TB, USB 3.0', '2023-01-04'),
	(442, 'Transcend StoreJet 25M3 2TB', 'Izdržljiv prijenosni HDD.', 499.99, 17, 60, 'transcend_storejet_25m3_2tb.jpg', '2TB, USB 3.0', '2023-01-05'),
	(443, 'LaCie Rugged Mini 2TB', 'Prijenosni HDD s otpornošću na udarce.', 699.99, 17, 50, 'lacie_rugged_mini_2tb.jpg', '2TB, USB 3.0', '2023-01-06'),
	(444, 'ADATA HD710 Pro 2TB', 'Vodootporni prijenosni HDD.', 599.99, 17, 40, 'adata_hd710_pro_2tb.jpg', '2TB, USB 3.0', '2023-01-07'),
	(445, 'G-Technology G-Drive Mobile 1TB', 'Prijenosni HDD s brzim prijenosom.', 799.99, 17, 30, 'g_technology_g_drive_mobile_1tb.jpg', '1TB, USB 3.0', '2023-01-08'),
	(446, 'Buffalo MiniStation 1TB', 'Prijenosni HDD s jednostavnim korištenjem.', 399.99, 17, 20, 'buffalo_ministation_1tb.jpg', '1TB, USB 3.0', '2023-01-09'),
	(447, 'Toshiba Canvio Basics 1TB', 'Jednostavan prijenosni HDD.', 399.99, 17, 10, 'toshiba_canvio_basics_1tb.jpg', '1TB, USB 3.0', '2023-01-10'),
	(448, 'Samsung T5 Portable SSD 500GB', 'Brzi prijenosni SSD.', 699.99, 17, 5, 'samsung_t5_portable_ssd_500gb.jpg', '500GB, USB 3.1', '2023-01-11'),
	(449, 'SanDisk Ultra Dual Drive 128GB', 'USB flash disk s dvostrukim konektorima.', 199.99, 17, 15, 'sandisk_ultra_dual_drive_128gb.jpg', '128GB, USB 3.0', '2023-01-12'),
	(450, 'Kingston DataTraveler 64GB', 'USB flash disk s velikim kapacitetom.', 99.99, 17, 25, 'kingston_datatraveler_64gb.jpg', '64GB, USB 3.0', '2023-01-13'),
	(451, 'Lexar JumpDrive 32GB', 'USB flash disk s brzim prijenosom.', 49.99, 17, 35, 'lexar_jumpdrive_32gb.jpg', '32GB, USB 3.0', '2023-01-14'),
	(452, 'PNY Turbo 128GB', 'USB flash disk s velikim kapacitetom.', 199.99, 17, 45, 'pny_turbo_128gb.jpg', '128GB, USB 3.0', '2023-01-15'),
	(453, 'Verbatim Store "n" Go 64GB', 'USB flash disk s velikim kapacitetom.', 49.99, 17, 55, 'verbatim_store_n_go_64gb.jpg', '64GB, USB 3.0', '2023-01-16'),
	(454, 'ADATA UV128 32GB', 'USB flash disk s modernim dizajnom.', 29.99, 17, 65, 'adata_uv128_32gb.jpg', '32GB, USB 3.0', '2023-01-17'),
	(455, 'SanDisk Cruzer Blade 16GB', 'USB flash disk s kompaktnim dizajnom.', 19.99, 17, 75, 'sandisk_cruzer_blade_16gb.jpg', '16GB, USB 2.0', '2023-01-18'),
	(456, 'Kingston DataTraveler 32GB', 'USB flash disk s velikim kapacitetom.', 29.99, 17, 85, 'kingston_datatraveler_32gb.jpg', '32GB, USB 3.0', '2023-01-19'),
	(457, 'Transcend JetFlash 700 64GB', 'USB flash disk s brzim prijenosom.', 49.99, 17, 95, 'transcend_jetflash_700_64gb.jpg', '64GB, USB 3.0', '2023-01-20'),
	(458, 'Samsung BAR Plus 128GB', 'USB flash disk s metalnim kućištem.', 79.99, 17, 105, 'samsung_bar_plus_128gb.jpg', '128GB, USB 3.1', '2023-01-21'),
	(459, 'SanDisk Ultra Fit 128GB', 'USB flash disk s malim oblikom.', 59.99, 17, 115, 'sandisk_ultra_fit_128gb.jpg', '128GB, USB 3.1', '2023-01-22'),
	(460, 'Lexar JumpDrive S57 64GB', 'USB flash disk s brzim prijenosom.', 39.99, 17, 125, 'lexar_jumpdrive_s57_64gb.jpg', '64GB, USB 3.0', '2023-01-23'),
	(461, 'PNY Attaché 4 32GB', 'USB flash disk s jednostavnim korištenjem.', 19.99, 17, 135, 'pny_attache_4_32gb.jpg', '32GB, USB 3.0', '2023-01-24'),
	(462, 'Verbatim Store "n" Go 128GB', 'USB flash disk s velikim kapacitetom.', 59.99, 17, 145, 'verbatim_store_n_go_128gb.jpg', '128GB, USB 3.0', '2023-01-25'),
	(463, 'ADATA HD710 Pro 1TB', 'Prijenosni HDD s vodootpornošću.', 699.99, 17, 155, 'adata_hd710_pro_1tb.jpg', '1TB, USB 3.0', '2023-01-26'),
	(464, 'Seagate Expansion 1TB', 'Prijenosni HDD s velikim kapacitetom.', 499.99, 17, 165, 'seagate_expansion_1tb.jpg', '1TB, USB 3.0', '2023-01-27'),
	(465, 'WD My Passport 1TB', 'Prijenosni HDD s brzim prijenosom.', 499.99, 17, 175, 'wd_my_passport_1tb.jpg', '1TB, USB 3.0', '2023-01-28'),
	(466, 'Toshiba Canvio Advance 1TB', 'Prijenosni HDD s modernim dizajnom.', 499.99, 17, 185, 'toshiba_canvio_advance_1tb.jpg', '1TB, USB 3.0', '2023-01-29'),
	(467, 'LaCie Rugged SSD 1TB', 'Prijenosni SSD s otpornošću na udarce.', 999.99, 17, 195, 'lacie_rugged_ssd_1tb.jpg', '1TB, USB 3.1', '2023-01-30'),
	(468, 'Apple iPhone 14', 'Najnoviji model iPhone-a.', 9999.99, 18, 100, 'apple_iphone_14.jpg', '128GB, A15 Bionic', '2023-01-01'),
	(469, 'Samsung Galaxy S23', 'Flagship model od Samsunga.', 8999.99, 18, 90, 'samsung_galaxy_s23.jpg', '256GB, Snapdragon 8 Gen 2', '2023-01-02'),
	(470, 'Google Pixel 7', 'Pametan telefon s odličnom kamerom.', 7499.99, 18, 80, 'google_pixel_7.jpg', '128GB, Google Tensor G2', '2023-01-03'),
	(471, 'OnePlus 11', 'Pametan telefon s brzim performansama.', 6999.99, 18, 70, 'oneplus_11.jpg', '256GB, Snapdragon 8 Gen 2', '2023-01-04'),
	(472, 'Xiaomi 13 Pro', 'Pametan telefon s odličnim specifikacijama.', 7999.99, 18, 60, 'xiaomi_13_pro.jpg', '256GB, Snapdragon 8 Gen 2', '2023-01-05'),
	(473, 'Sony Xperia 1 IV', 'Pametan telefon s 4K ekranom.', 10999.99, 18, 50, 'sony_xperia_1_iv.jpg', '256GB, Snapdragon 8 Gen 1', '2023-01-06'),
	(474, 'Oppo Find X5 Pro', 'Pametan telefon s vrhunskim kamerama.', 8999.99, 18, 40, 'oppo_find_x5_pro.jpg', '256GB, Snapdragon 8 Gen 1', '2023-01-07'),
	(475, 'Vivo X80 Pro', 'Pametan telefon s odličnim performansama.', 7999.99, 18, 30, 'vivo_x80_pro.jpg', '256GB, Snapdragon 8 Gen 1', '2023-01-08'),
	(476, 'Realme GT 2 Pro', 'Pametan telefon s brzim punjenjem.', 6499.99, 18, 20, 'realme_gt_2_pro.jpg', '256GB, Snapdragon 8 Gen 1', '2023-01-09'),
	(477, 'Nokia G50', 'Pristupačan pametan telefon.', 2999.99, 18, 10, 'nokia_g50.jpg', '64GB, Snapdragon 480', '2023-01-10'),
	(478, 'Motorola Edge 30', 'Pametan telefon s odličnim dizajnom.', 4999.99, 18, 5, 'motorola_edge_30.jpg', '128GB, Snapdragon 778G', '2023-01-11'),
	(479, 'Huawei P50 Pro', 'Pametan telefon s vrhunskim kamerama.', 8999.99, 18, 15, 'huawei_p50_pro.jpg', '256GB, Kirin 9000', '2023-01-12'),
	(480, 'Asus ROG Phone 6', 'Gaming pametan telefon.', 9999.99, 18, 25, 'asus_rog_phone_6.jpg', '512GB, Snapdragon 8+ Gen 1', '2023-01-13'),
	(481, 'ZTE Axon 20', 'Pametan telefon s pod ekranom kamerom.', 4999.99, 18, 35, 'zte_axon_20.jpg', '128GB, Snapdragon 765G', '2023-01-14'),
	(482, 'LG Velvet', 'Pametan telefon s elegantnim dizajnom.', 4999.99, 18, 45, 'lg_velvet.jpg', '128GB, Snapdragon 765G', '2023-01-15'),
	(483, 'HTC Desire 21 Pro', 'Pametan telefon s velikim ekranom.', 3999.99, 18, 55, 'htc_desire_21_pro.jpg', '128GB, Snapdragon 690', '2023-01-16'),
	(484, 'Honor 50', 'Pametan telefon s odličnim kamerama.', 5999.99, 18, 65, 'honor_50.jpg', '128GB, Snapdragon 778G', '2023-01-17'),
	(485, 'Sony Xperia 10 IV', 'Pametan telefon s odličnim performansama.', 4999.99, 18, 85, 'sony_xperia_10_iv.jpg', '128GB, Snapdragon 695', '2023-01-19'),
	(486, 'Nokia X20', 'Pametan telefon s 5G podrškom.', 3999.99, 18, 95, 'nokia_x20.jpg', '128GB, Snapdragon 480', '2023-01-20'),
	(487, 'Motorola Moto G Power (2022)', 'Pametan telefon s dugim trajanjem baterije.', 2999.99, 18, 105, 'motorola_moto_g_power_2022.jpg', '64GB, MediaTek Helio G37', '2023-01-21'),
	(488, 'Samsung Galaxy A53', 'Pametan telefon s odličnim kamerama.', 4999.99, 18, 115, 'samsung_galaxy_a53.jpg', '128GB, Exynos 1280', '2023-01-22'),
	(489, 'Xiaomi Redmi Note 11', 'Pametan telefon s odličnim performansama.', 2999.99, 18, 125, 'xiaomi_redmi_note_11.jpg', '128GB, Snapdragon 680', '2023-01-23'),
	(490, 'Realme 9 Pro+', 'Pametan telefon s odličnim kamerama.', 4999.99, 18, 135, 'realme_9_pro_plus.jpg', '128GB, MediaTek Dimensity 920', '2023-01-24'),
	(491, 'Oppo Reno 7', 'Pametan telefon s modernim dizajnom.', 4999.99, 18, 145, 'oppo_reno_7.jpg', '256GB, MediaTek Dimensity 900', '2023-01-25'),
	(492, 'Vivo V21e', 'Pametan telefon s odličnim kamerama.', 3999.99, 18, 155, 'vivo_v21e.jpg', '128GB, MediaTek Helio G70', '2023-01-26'),
	(493, 'Honor 50 Lite', 'Pametan telefon s modernim dizajnom.', 3999.99, 18, 165, 'honor_50_lite.jpg', '128GB, MediaTek Dimensity 900', '2023-01-27'),
	(494, 'Infinix Zero 5G', 'Pametan telefon s 5G podrškom.', 2999.99, 18, 175, 'infinix_zero_5g.jpg', '128GB, MediaTek Dimensity 900', '2023-01-28'),
	(495, 'Tecno Pova 5', 'Pametan telefon s velikom baterijom.', 1999.99, 18, 185, 'tecno_pova_5.jpg', '128GB, MediaTek Helio G85', '2023-01-29'),
	(496, 'ZTE Blade V30', 'Pametan telefon s modernim dizajnom.', 2999.99, 18, 195, 'zte_blade_v30.jpg', '128GB, Unisoc T606', '2023-01-30'),
	(497, 'DJI Mavic Air 2', 'Dron s naprednim kamerama za visokokvalitetne snimke.', 7500.00, 20, 10, 'dji_mavic_air_2.jpg', 'Kamera: 48MP, Domet: 10km, Trajanje leta: 34 min.', '2024-11-16'),
	(498, 'DJI Mini 3 Pro', 'Lagani i kompaktni dron s moćnim performansama.', 5700.00, 20, 15, 'dji_mini_3_pro.jpg', 'Kamera: 4K, Domet: 12km, Trajanje leta: 31 min.', '2024-11-16'),
	(499, 'Autel EVO Lite+', 'Dron s 1-inčnim senzorom kamere za profesionalne snimke.', 8700.00, 20, 8, 'autel_evo_lite_plus.jpg', 'Kamera: 20MP, Domet: 15km, Trajanje leta: 40 min.', '2024-11-16'),
	(500, 'DJI FPV Combo', 'Brzi dron s FPV iskustvom.', 9500.00, 20, 6, 'dji_fpv_combo.jpg', 'Kamera: 4K, Maksimalna brzina: 140 km/h, Trajanje leta: 20 min.', '2024-11-16'),
	(501, 'Parrot Anafi', 'Praktični dron za putovanja.', 4200.00, 20, 20, 'parrot_anafi.jpg', 'Kamera: 21MP, Domet: 4km, Trajanje leta: 25 min.', '2024-11-16'),
	(502, 'Holy Stone HS720E', 'Pristupačni dron s naprednim značajkama.', 3200.00, 20, 25, 'holy_stone_hs720e.jpg', 'Kamera: 4K, GPS sustav, Trajanje leta: 23 min.', '2024-11-16'),
	(503, 'DJI Inspire 2', 'Profesionalni dron za snimatelje.', 25000.00, 20, 3, 'dji_inspire_2.jpg', 'Kamera: 5.2K, Domet: 7km, Trajanje leta: 27 min.', '2024-11-16'),
	(504, 'Ryze Tello', 'Mini dron za početnike i zabavu.', 1000.00, 20, 50, 'ryze_tello.jpg', 'Kamera: 5MP, Domet: 100m, Trajanje leta: 13 min.', '2024-11-16'),
	(505, 'DJI Phantom 4 Pro', 'Robustan dron s naprednim senzorima.', 11000.00, 20, 7, 'dji_phantom_4_pro.jpg', 'Kamera: 20MP, Domet: 8km, Trajanje leta: 30 min.', '2024-11-16'),
	(506, 'FIMI X8 Mini', 'Kompaktni dron s odličnim značajkama.', 3600.00, 20, 18, 'fimi_x8_mini.jpg', 'Kamera: 4K, Domet: 8km, Trajanje leta: 31 min.', '2024-11-16'),
	(507, 'DJI Air 2S', 'Napredni dron s 1-inčnim senzorom.', 8200.00, 20, 12, 'dji_air_2s.jpg', 'Kamera: 20MP, Domet: 12km, Trajanje leta: 31 min.', '2024-11-16'),
	(508, 'Hubsan Zino Mini Pro', 'Dron s inteligentnim funkcijama.', 5400.00, 20, 15, 'hubsan_zino_mini_pro.jpg', 'Kamera: 4K, Domet: 10km, Trajanje leta: 40 min.', '2024-11-16'),
	(509, 'Parrot Bebop 2', 'Jednostavan dron za rekreativne korisnike.', 3000.00, 20, 20, 'parrot_bebop_2.jpg', 'Kamera: 14MP, Domet: 2km, Trajanje leta: 25 min.', '2024-11-16'),
	(510, 'Autel Robotics EVO II', 'Moćni dron s 8K kamerom.', 13500.00, 20, 5, 'autel_evo_ii.jpg', 'Kamera: 48MP, Domet: 9km, Trajanje leta: 40 min.', '2024-11-16'),
	(511, 'DJI Mini SE', 'Povoljni dron za osnovne korisnike.', 2600.00, 20, 22, 'dji_mini_se.jpg', 'Kamera: 2.7K, Domet: 4km, Trajanje leta: 30 min.', '2024-11-16'),
	(512, 'PowerVision PowerEgg X', 'Višenamjenski dron i kamera.', 7800.00, 20, 10, 'powervision_poweregg_x.jpg', 'Kamera: 4K, Vodootporan, Trajanje leta: 30 min.', '2024-11-16'),
	(513, 'Walkera Vitus 320', 'Prijenosni dron s odličnim kamerama.', 6800.00, 20, 8, 'walkera_vitus_320.jpg', 'Kamera: 12MP, Domet: 5km, Trajanje leta: 25 min.', '2024-11-16'),
	(514, 'Snaptain SP500', 'Pristupačan dron s GPS sustavom.', 2200.00, 20, 30, 'snaptain_sp500.jpg', 'Kamera: 1080p, Domet: 1.5km, Trajanje leta: 15 min.', '2024-11-16'),
	(515, 'Yuneec Typhoon H', 'Dron s 360° rotirajućom kamerom.', 10500.00, 20, 5, 'yuneec_typhoon_h.jpg', 'Kamera: 4K, Domet: 1.6km, Trajanje leta: 25 min.', '2024-11-16'),
	(516, 'Parrot Disco', 'FPV dron s jedinstvenim dizajnom.', 6200.00, 20, 12, 'parrot_disco.jpg', 'Kamera: 14MP, Domet: 2km, Trajanje leta: 45 min.', '2024-11-16'),
	(517, 'DJI Mavic 3', 'Dron s dvostrukom kamerom i vrhunskim značajkama.', 14500.00, 20, 4, 'dji_mavic_3.jpg', 'Kamera: 20MP + 12MP, Domet: 15km, Trajanje leta: 46 min.', '2024-11-16'),
	(518, 'Potensic T25', 'Pristupačni dron za početnike.', 1600.00, 20, 30, 'potensic_t25.jpg', 'Kamera: 1080p, GPS sustav, Trajanje leta: 10 min.', '2024-11-16'),
	(519, 'Skydio 2+', 'Autonomni dron s naprednom AI tehnologijom.', 9500.00, 20, 8, 'skydio_2_plus.jpg', 'Kamera: 4K, Domet: 6km, Trajanje leta: 27 min.', '2024-11-16'),
	(520, 'EACHINE E58', 'Mini dron za rekreativnu zabavu.', 900.00, 20, 40, 'eachine_e58.jpg', 'Kamera: 720p, Domet: 80m, Trajanje leta: 9 min.', '2024-11-16'),
	(521, 'DJI Phantom SE', 'Pouzdani dron s moćnom kamerom.', 9600.00, 20, 6, 'dji_phantom_se.jpg', 'Kamera: 4K, Domet: 5km, Trajanje leta: 25 min.', '2024-11-16'),
	(522, 'Ruko F11 Pro', 'Dron s GPS sustavom i dugačkim dometom.', 3600.00, 20, 18, 'ruko_f11_pro.jpg', 'Kamera: 4K, Domet: 1.2km, Trajanje leta: 30 min.', '2024-11-16'),
	(523, 'Autel EVO Nano+', 'Lagani dron s naprednim značajkama.', 5200.00, 20, 15, 'autel_evo_nano_plus.jpg', 'Kamera: 50MP, Domet: 10km, Trajanje leta: 28 min.', '2024-11-16'),
	(524, 'MJX Bugs 12 EIS', 'Dron srednje klase s GPS sustavom.', 2500.00, 20, 20, 'mjx_bugs_12_eis.jpg', 'Kamera: 4K, Domet: 800m, Trajanje leta: 22 min.', '2024-11-16'),
	(525, 'Parrot Swing', 'FPV dron s jedinstvenim X-oblikom.', 1800.00, 20, 30, 'parrot_swing.jpg', 'Kamera: 720p, Domet: 300m, Trajanje leta: 8 min.', '2024-11-16'),
	(526, 'Canon LaserJet 1200', 'Laserski printer visokih performansi.', 2000.00, 13, 15, 'canon_laserjet_1200.jpg', 'Rezolucija: 1200 dpi, Brzina ispisa: 20 stranica/min.', '2024-11-16'),
	(527, 'HP Inkjet 2710', 'Kompaktni inkjet printer s Wi-Fi povezivanjem.', 850.00, 13, 10, 'hp_inkjet_2710.jpg', 'Rezolucija: 4800 dpi, Brzina ispisa: 10 stranica/min.', '2024-11-16'),
	(528, 'Epson EcoTank L3150', 'Printer s visokokapacitetnim spremnikom tinte.', 1200.00, 13, 8, 'epson_ecotank_l3150.jpg', 'Kapacitet: 6500 stranica, Brzina ispisa: 15 stranica/min.', '2024-11-16'),
	(529, 'Brother HL-L2350DW', 'Kompaktni monokromatski laserski printer.', 1200.00, 13, 20, 'brother_hl_l2350dw.jpg', 'Rezolucija: 2400 x 600 dpi, Brzina ispisa: 30 stranica/min.', '2024-11-16'),
	(530, 'Canon PIXMA G3410', 'Višenamjenski printer s Wi-Fi funkcijom.', 1400.00, 13, 15, 'canon_pixma_g3410.jpg', 'Rezolucija: 4800 x 1200 dpi, Brzina ispisa: 8 stranica/min.', '2024-11-16'),
	(531, 'HP DeskJet Plus 4120', 'Povoljni printer s mobilnim ispisom.', 850.00, 13, 25, 'hp_deskjet_plus_4120.jpg', 'Rezolucija: 4800 x 1200 dpi, Brzina ispisa: 7.5 stranica/min.', '2024-11-16'),
	(532, 'Epson WorkForce WF-2830', 'Multifunkcijski printer s obostranim ispisom.', 1100.00, 13, 10, 'epson_workforce_wf2830.jpg', 'Rezolucija: 5760 x 1440 dpi, Brzina ispisa: 10 stranica/min.', '2024-11-16'),
	(533, 'Samsung Xpress M2020W', 'Brzi laserski printer za uredsku upotrebu.', 1350.00, 13, 8, 'samsung_xpress_m2020w.jpg', 'Rezolucija: 1200 x 1200 dpi, Brzina ispisa: 21 stranica/min.', '2024-11-16'),
	(534, 'Canon i-SENSYS MF643Cdw', 'Višenamjenski laserski printer u boji.', 2300.00, 13, 5, 'canon_isensys_mf643cdw.jpg', 'Rezolucija: 1200 dpi, Brzina ispisa: 21 stranica/min.', '2024-11-16'),
	(535, 'Brother DCP-L3550CDW', 'Multifunkcijski printer s Wi-Fi funkcijom.', 2500.00, 13, 12, 'brother_dcp_l3550cdw.jpg', 'Rezolucija: 2400 dpi, Brzina ispisa: 18 stranica/min.', '2024-11-16'),
	(536, 'Epson EcoTank L850', 'Printer s funkcijom ispisa fotografija.', 4000.00, 13, 7, 'epson_ecotank_l850.jpg', 'Rezolucija: 5760 x 1440 dpi, Foto ispis.', '2024-11-16'),
	(537, 'HP LaserJet Pro MFP M428fdw', 'Višenamjenski printer s brzim ispisom.', 3200.00, 13, 6, 'hp_laserjet_pro_mfp_m428fdw.jpg', 'Rezolucija: 1200 dpi, Brzina ispisa: 38 stranica/min.', '2024-11-16'),
	(538, 'Canon PIXMA TR4550', 'Povoljni printer za kućnu upotrebu.', 700.00, 13, 20, 'canon_pixma_tr4550.jpg', 'Rezolucija: 4800 dpi, Brzina ispisa: 8 stranica/min.', '2024-11-16'),
	(539, 'Brother MFC-L3750CDW', 'Multifunkcijski laserski printer u boji.', 2700.00, 13, 10, 'brother_mfc_l3750cdw.jpg', 'Rezolucija: 2400 dpi, Brzina ispisa: 19 stranica/min.', '2024-11-16'),
	(540, 'Epson Expression Home XP-3100', 'Višenamjenski kompaktni printer.', 950.00, 13, 15, 'epson_expression_home_xp3100.jpg', 'Rezolucija: 5760 dpi, Brzina ispisa: 10 stranica/min.', '2024-11-16'),
	(541, 'HP ENVY Photo 7134', 'Printer za visokokvalitetne fotografije.', 2000.00, 13, 8, 'hp_envy_photo_7134.jpg', 'Rezolucija: 4800 dpi, Foto ispis.', '2024-11-16'),
	(542, 'Canon MAXIFY GX7050', 'Printer visokog kapaciteta za poslovne potrebe.', 4500.00, 13, 3, 'canon_maxify_gx7050.jpg', 'Rezolucija: 1200 dpi, Kapacitet: 9000 stranica.', '2024-11-16'),
	(543, 'Brother HL-L2375DW', 'Brzi monokromatski laserski printer.', 1400.00, 13, 18, 'brother_hl_l2375dw.jpg', 'Rezolucija: 2400 dpi, Brzina ispisa: 34 stranica/min.', '2024-11-16'),
	(544, 'Epson SureColor SC-P700', 'Profesionalni foto printer.', 5500.00, 13, 2, 'epson_surecolor_scp700.jpg', 'Rezolucija: 5760 dpi, Foto ispis.', '2024-11-16'),
	(545, 'HP OfficeJet Pro 9015e', 'Printer za mala poduzeća.', 1800.00, 13, 10, 'hp_officejet_pro_9015e.jpg', 'Rezolucija: 4800 dpi, Brzina ispisa: 24 stranica/min.', '2024-11-16'),
	(546, 'Canon PIXMA G6050', 'Printer s visokim kapacitetom tinte.', 3000.00, 13, 5, 'canon_pixma_g6050.jpg', 'Kapacitet: 18000 stranica, Rezolucija: 4800 dpi.', '2024-11-16'),
	(547, 'Brother DCP-1623WE', 'Jednostavan laserski printer za kućnu upotrebu.', 1200.00, 13, 25, 'brother_dcp_1623we.jpg', 'Rezolucija: 2400 dpi, Brzina ispisa: 20 stranica/min.', '2024-11-16'),
	(548, 'Epson EcoTank L5190', 'Multifunkcijski printer s funkcijom faksa.', 2800.00, 13, 12, 'epson_ecotank_l5190.jpg', 'Rezolucija: 5760 dpi, Kapacitet tinte: 6500 stranica.', '2024-11-16'),
	(549, 'HP LaserJet Pro M15w', 'Najmanji laserski printer na tržištu.', 750.00, 13, 20, 'hp_laserjet_pro_m15w.jpg', 'Rezolucija: 600 dpi, Brzina ispisa: 19 stranica/min.', '2024-11-16'),
	(550, 'Canon i-SENSYS MF3010', 'Kompaktan i povoljan laserski printer.', 1200.00, 13, 15, 'canon_isensys_mf3010.jpg', 'Rezolucija: 600 dpi, Brzina ispisa: 18 stranica/min.', '2024-11-16'),
	(551, 'Epson Stylus Photo R3000', 'Profesionalni printer za velike formate.', 6500.00, 13, 3, 'epson_stylus_photo_r3000.jpg', 'Rezolucija: 5760 dpi, Format: A3.', '2024-11-16'),
	(552, 'Brother HL-L8260CDW', 'Laserski printer u boji za uredske korisnike.', 3500.00, 13, 7, 'brother_hl_l8260cdw.jpg', 'Rezolucija: 2400 dpi, Brzina ispisa: 31 stranica/min.', '2024-11-16'),
	(553, 'Canon PIXMA iP8750', 'Printer za ispis fotografija u velikim formatima.', 4500.00, 13, 4, 'canon_pixma_ip8750.jpg', 'Rezolucija: 9600 dpi, Foto ispis.', '2024-11-16'),
	(554, 'HP DeskJet 2720e', 'Jednostavan printer za svakodnevne zadatke.', 600.00, 13, 30, 'hp_deskjet_2720e.jpg', 'Rezolucija: 4800 dpi, Brzina ispisa: 7.5 stranica/min.', '2024-11-16'),
	(555, 'Apple iPad Air 10.9', 'Tanak i lagan tablet s A14 Bionic čipom.', 5400.00, 19, 20, 'ipad_air_10.9.jpg', 'Ekran: 10.9", Čip: A14 Bionic, Pohrana: 64GB.', '2024-11-16'),
	(556, 'Samsung Galaxy Tab S8', 'Premium Android tablet sa Snapdragon procesorom.', 7300.00, 19, 15, 'galaxy_tab_s8.jpg', 'Ekran: 11", Procesor: Snapdragon 8 Gen 1, Pohrana: 128GB.', '2024-11-16'),
	(557, 'Lenovo Tab P11 Pro', 'Tablet s OLED ekranom i odličnom baterijom.', 4900.00, 19, 12, 'lenovo_tab_p11_pro.jpg', 'Ekran: 11.5" OLED, RAM: 6GB, Pohrana: 128GB.', '2024-11-16'),
	(558, 'Xiaomi Pad 6', 'Snažan tablet za rad i zabavu.', 3500.00, 19, 25, 'xiaomi_pad_6.jpg', 'Ekran: 11", Procesor: Snapdragon 870, Pohrana: 128GB.', '2024-11-16'),
	(559, 'Microsoft Surface Pro 9', '2-u-1 uređaj za profesionalne korisnike.', 9600.00, 19, 5, 'surface_pro_9.jpg', 'Ekran: 13", Procesor: Intel i5, RAM: 8GB, Pohrana: 256GB.', '2024-11-16'),
	(560, 'Huawei MatePad 11', 'Android tablet s HarmonyOS sustavom.', 4200.00, 19, 10, 'huawei_matepad_11.jpg', 'Ekran: 11", Procesor: Snapdragon 865, Pohrana: 128GB.', '2024-11-16'),
	(561, 'Apple iPad Mini 6', 'Kompaktni tablet s A15 Bionic čipom.', 5200.00, 19, 15, 'ipad_mini_6.jpg', 'Ekran: 8.3", Pohrana: 64GB.', '2024-11-16'),
	(562, 'Samsung Galaxy Tab A8', 'Pristupačan tablet za osnovne potrebe.', 1700.00, 19, 30, 'galaxy_tab_a8.jpg', 'Ekran: 10.5", Procesor: Unisoc T618, Pohrana: 32GB.', '2024-11-16'),
	(563, 'Lenovo Yoga Tab 13', 'Tablet s ugrađenim stalkom.', 6400.00, 19, 8, 'lenovo_yoga_tab_13.jpg', 'Ekran: 13", Procesor: Snapdragon 870, RAM: 8GB.', '2024-11-16'),
	(564, 'Xiaomi Redmi Pad', 'Odličan omjer cijene i kvalitete.', 2800.00, 19, 25, 'redmi_pad.jpg', 'Ekran: 10.6", Procesor: MediaTek Helio G99, Pohrana: 128GB.', '2024-11-16'),
	(565, 'Microsoft Surface Go 3', 'Kompaktan uređaj za posao i školu.', 4500.00, 19, 18, 'surface_go_3.jpg', 'Ekran: 10.5", Procesor: Intel Pentium, Pohrana: 64GB.', '2024-11-16'),
	(566, 'Apple iPad Pro 12.9', 'Najmoćniji tablet na tržištu.', 12200.00, 19, 4, 'ipad_pro_12.9.jpg', 'Ekran: 12.9", Čip: M2, Pohrana: 128GB.', '2024-11-16'),
	(567, 'Samsung Galaxy Tab S7 FE', 'Tablet srednje klase s velikim ekranom.', 4800.00, 19, 12, 'galaxy_tab_s7_fe.jpg', 'Ekran: 12.4", Procesor: Snapdragon 750G, Pohrana: 64GB.', '2024-11-16'),
	(568, 'Lenovo Tab M10 HD', 'Osnovni tablet za kućnu upotrebu.', 1400.00, 19, 30, 'lenovo_tab_m10_hd.jpg', 'Ekran: 10.1", Procesor: MediaTek Helio P22T, Pohrana: 32GB.', '2024-11-16'),
	(569, 'Xiaomi Pad 5', 'Tablet s moćnim performansama.', 3800.00, 19, 10, 'xiaomi_pad_5.jpg', 'Ekran: 11", Procesor: Snapdragon 860, Pohrana: 128GB.', '2024-11-16'),
	(570, 'Apple iPad 10th Gen', 'iPad s USB-C povezivanjem.', 5000.00, 19, 20, 'ipad_10th_gen.jpg', 'Ekran: 10.9", Pohrana: 64GB.', '2024-11-16'),
	(571, 'Samsung Galaxy Tab Active3', 'Izdržljiv tablet za terenske korisnike.', 5500.00, 19, 8, 'galaxy_tab_active3.jpg', 'Ekran: 8", Procesor: Exynos 9810, Pohrana: 64GB.', '2024-11-16'),
	(572, 'Huawei MatePad Pro', 'Premium tablet s vrhunskim ekranom.', 7600.00, 19, 6, 'matepad_pro.jpg', 'Ekran: 12.6" OLED, Procesor: Kirin 9000E.', '2024-11-16'),
	(573, 'Lenovo Tab P11', 'Tablet s dugim trajanjem baterije.', 2900.00, 19, 22, 'lenovo_tab_p11.jpg', 'Ekran: 11", RAM: 4GB, Pohrana: 64GB.', '2024-11-16'),
	(574, 'Samsung Galaxy Tab S6 Lite', 'Tablet s olovkom za bilješke.', 3400.00, 19, 15, 'galaxy_tab_s6_lite.jpg', 'Ekran: 10.4", Procesor: Exynos 9611, Pohrana: 64GB.', '2024-11-16'),
	(575, 'Xiaomi Mi Pad 5 Pro', 'Tablet s moćnim performansama za zabavu.', 5000.00, 19, 18, 'mi_pad_5_pro.jpg', 'Ekran: 11", Procesor: Snapdragon 870, Pohrana: 128GB.', '2024-11-16'),
	(576, 'Apple iPad 9th Gen', 'Osnovni model iPada za svakodnevnu upotrebu.', 3700.00, 19, 25, 'ipad_9th_gen.jpg', 'Ekran: 10.2", Pohrana: 64GB.', '2024-11-16'),
	(577, 'Samsung Galaxy Tab S8 Ultra', 'Najveći i najsnažniji Galaxy tablet.', 9700.00, 19, 3, 'galaxy_tab_s8_ultra.jpg', 'Ekran: 14.6", Procesor: Snapdragon 8 Gen 1, Pohrana: 256GB.', '2024-11-16'),
	(578, 'Lenovo Tab M8 HD', 'Kompaktan i povoljan tablet.', 1200.00, 19, 35, 'lenovo_tab_m8_hd.jpg', 'Ekran: 8", Procesor: MediaTek A22, Pohrana: 32GB.', '2024-11-16'),
	(579, 'Samsung Galaxy Tab S6', 'Tablet s vrhunskom olovkom.', 6800.00, 19, 8, 'galaxy_tab_s6.jpg', 'Ekran: 10.5", Procesor: Snapdragon 855, Pohrana: 128GB.', '2024-11-16'),
	(580, 'Apple iPad Pro 11', 'Tablet s M2 čipom za profesionalce.', 11500.00, 19, 4, 'ipad_pro_11.jpg', 'Ekran: 11", Pohrana: 128GB.', '2024-11-16'),
	(581, 'Huawei MediaPad T5', 'Osnovni tablet za zabavu i rad.', 1800.00, 19, 28, 'mediapad_t5.jpg', 'Ekran: 10.1", Procesor: Kirin 659, Pohrana: 32GB.', '2024-11-16'),
	(582, 'Microsoft Surface Duo 2', 'Dvostruki ekran za produktivnost.', 14500.00, 19, 2, 'surface_duo_2.jpg', 'Ekran: 8.3", Procesor: Snapdragon 888.', '2024-11-16'),
	(583, 'Sony Alpha a7 III', 'Mirrorless fotoaparat s naprednim senzorom.', 15000.00, 21, 10, 'sony_alpha_a7_iii.jpg', 'Senzor: 24.2 MP, Video: 4K, Stabilizacija: Da.', '2024-11-16'),
	(584, 'Canon EOS R5', 'Profesionalni fotoaparat za fotografiju i video.', 29000.00, 21, 5, 'canon_eos_r5.jpg', 'Senzor: 45 MP, Video: 8K, Stabilizacija: Da.', '2024-11-16'),
	(585, 'Nikon Z6 II', 'Svestrani mirrorless fotoaparat.', 18000.00, 21, 8, 'nikon_z6_ii.jpg', 'Senzor: 24.5 MP, Video: 4K UHD, Autofokus: Da.', '2024-11-16'),
	(586, 'GoPro HERO11 Black', 'Akcijska kamera za ekstremne uvjete.', 3200.00, 21, 20, 'gopro_hero11_black.jpg', 'Rezolucija: 5.3K, Vodootporna: Do 10m, Stabilizacija: HyperSmooth.', '2024-11-16'),
	(587, 'DJI Osmo Action 3', 'Akcijska kamera s vrhunskim funkcijama.', 2700.00, 21, 15, 'dji_osmo_action_3.jpg', 'Rezolucija: 4K HDR, Vodootporna: Da, FOV: 155°.', '2024-11-16'),
	(588, 'Fujifilm X-T4', 'Mirrorless kamera za kreativne korisnike.', 13500.00, 21, 6, 'fujifilm_xt4.jpg', 'Senzor: 26 MP, Video: 4K, Stabilizacija: IBIS.', '2024-11-16'),
	(589, 'Panasonic Lumix GH6', 'Profesionalna kamera za video produkciju.', 17000.00, 21, 4, 'panasonic_lumix_gh6.jpg', 'Senzor: 25 MP, Video: 5.7K, Mikrofon: Da.', '2024-11-16'),
	(590, 'Olympus OM-D E-M1 Mark III', 'Lagana kamera za profesionalce.', 14000.00, 21, 7, 'olympus_omd_em1_mark_iii.jpg', 'Senzor: 20 MP, Stabilizacija: Da, Brzina: 60 fps.', '2024-11-16'),
	(591, 'Canon PowerShot G7 X Mark III', 'Kompaktna kamera s odličnim performansama.', 5500.00, 21, 12, 'canon_powershot_g7x.jpg', 'Senzor: 20.1 MP, Video: 4K, Stabilizacija: Da.', '2024-11-16'),
	(592, 'Sony ZV-1', 'Kamera za vloggere.', 6500.00, 21, 10, 'sony_zv1.jpg', 'Senzor: 20.1 MP, Video: 4K, Mikrofon: Ug. mikrofon.', '2024-11-16'),
	(593, 'Insta360 ONE RS', 'Modularna akcijska kamera.', 3500.00, 21, 15, 'insta360_one_rs.jpg', 'Rezolucija: 5.7K, Vodootporna: Da, 360° video: Da.', '2024-11-16'),
	(594, 'Leica Q2', 'Premium kompaktni fotoaparat.', 46000.00, 21, 2, 'leica_q2.jpg', 'Senzor: 47.3 MP, Objektiv: 28mm, Stabilizacija: Da.', '2024-11-16'),
	(595, 'Ricoh GR III', 'Kompaktna kamera s visokim performansama.', 7000.00, 21, 10, 'ricoh_gr_iii.jpg', 'Senzor: 24 MP, Video: Full HD, Stabilizacija: Da.', '2024-11-16'),
	(596, 'Sony FX3', 'Kompaktna cinema kamera za profesionalce.', 29000.00, 21, 3, 'sony_fx3.jpg', 'Senzor: 10.2 MP, Video: 4K, Dinamički raspon: 15+ stopa.', '2024-11-16'),
	(597, 'DJI Pocket 2', 'Kompaktna ručna kamera.', 3800.00, 21, 12, 'dji_pocket_2.jpg', 'Rezolucija: 4K, Stabilizacija: Gimbal, Zvuk: Stereo.', '2024-11-16'),
	(598, 'Blackmagic Pocket Cinema Camera 6K', 'Cinema kamera za video produkciju.', 22000.00, 21, 4, 'blackmagic_6k.jpg', 'Senzor: 6K, Video: RAW, Dinamički raspon: 13 stopa.', '2024-11-16'),
	(599, 'Canon EOS M50 Mark II', 'Povoljna mirrorless kamera.', 7000.00, 21, 12, 'canon_eos_m50_mk2.jpg', 'Senzor: 24 MP, Video: 4K, Autofokus: Dual Pixel.', '2024-11-16'),
	(600, 'Panasonic Lumix S5', 'Mirrorless kamera s odličnim performansama.', 12500.00, 21, 5, 'panasonic_lumix_s5.jpg', 'Senzor: 24 MP, Video: 4K 60fps, Stabilizacija: Da.', '2024-11-16'),
	(601, 'Sony Alpha ZV-E10', 'Mirrorless kamera za vlogere.', 8500.00, 21, 10, 'sony_alpha_zve10.jpg', 'Senzor: 24.2 MP, Video: 4K, Mikrofon: Ug. mikrofon.', '2024-11-16'),
	(602, 'Nikon Coolpix P1000', 'Superzoom kamera.', 12000.00, 21, 8, 'nikon_coolpix_p1000.jpg', 'Zoom: 125x, Rezolucija: 16 MP, Video: 4K.', '2024-11-16'),
	(603, 'Leica M10-R', 'Napredna digitalna kamera.', 25000.00, 21, 3, 'leica_m10r.jpg', 'Senzor: 40 MP, Objektiv: 35mm, Stabilizacija: Ne.', '2024-11-16'),
	(604, 'Sigma fp L', 'Kompaktna kamera s punim formatom.', 17000.00, 21, 7, 'sigma_fp_l.jpg', 'Senzor: 61 MP, Video: 4K, RAW: Da.', '2024-11-16'),
	(605, 'Panasonic Lumix G85', 'Kamera s 4K video mogućnostima.', 8500.00, 21, 18, 'panasonic_lumix_g85.jpg', 'Senzor: 16 MP, Video: 4K, Stabilizacija: IBIS.', '2024-11-16'),
	(606, 'Fujifilm X100V', 'Kompaktna kamera za ljubitelje fotografije.', 13000.00, 21, 10, 'fujifilm_x100v.jpg', 'Senzor: 26 MP, Objektiv: 23mm, Stabilizacija: Da.', '2024-11-16'),
	(607, 'Nikon D850', 'Profesionalna DSLR kamera.', 27000.00, 21, 6, 'nikon_d850.jpg', 'Senzor: 45.7 MP, Video: 4K UHD, Autofokus: 153 točke.', '2024-11-16'),
	(608, 'Sony RX100 VII', 'Kompaktna kamera s odličnim performansama.', 9500.00, 21, 14, 'sony_rx100vii.jpg', 'Senzor: 20.1 MP, Video: 4K, Stabilizacija: Da.', '2024-11-16'),
	(609, 'Bose QuietComfort 35 II', 'Bežične slušalice s aktivnim poništavanjem buke.', 1700.00, 22, 12, 'bose_qc35_ii.jpg', 'Bluetooth: Da, Poništavanje buke: Da, Autonomija: 20h.', '2024-11-16'),
	(610, 'Sony WH-1000XM5', 'Bežične slušalice s najboljim poništavanjem buke.', 2000.00, 22, 8, 'sony_wh1000xm5.jpg', 'Bluetooth: Da, Poništavanje buke: Da, Autonomija: 30h.', '2024-11-16'),
	(611, 'Sennheiser Momentum 3', 'Bežične slušalice s visokom kvalitetom zvuka.', 2200.00, 22, 10, 'sennheiser_momentum_3.jpg', 'Bluetooth: Da, Poništavanje buke: Da, Autonomija: 17h.', '2024-11-16'),
	(612, 'JBL Quantum 800', 'Gaming slušalice s bežičnom vezom i surround zvukom.', 1500.00, 22, 14, 'jbl_quantum_800.jpg', 'Bluetooth: Da, Surround: Da, Autonomija: 14h.', '2024-11-16'),
	(613, 'Bose SoundLink Revolve+', 'Bežični zvučnik s 360° zvukom.', 2200.00, 22, 12, 'bose_soundlink_revolve_plus.jpg', 'Bluetooth: Da, Vodootporan: Da, Autonomija: 16h.', '2024-11-16'),
	(614, 'Sonos One', 'Pametan zvučnik s integriranim Amazon Alexa.', 2000.00, 22, 10, 'sonos_one.jpg', 'Wi-Fi: Da, Alexa: Da, Autonomija: Neograničena (s mrežom).', '2024-11-16'),
	(615, 'Marshall Stanmore II', 'Snažan zvučnik s retro dizajnom.', 2500.00, 22, 6, 'marshall_stanmore_ii.jpg', 'Bluetooth: Da, Kablovski ulaz: Da, Autonomija: Neograničena (s mrežom).', '2024-11-16'),
	(616, 'Sony SRS-XB43', 'Zvučnik s EXTRA BASS tehnologijom.', 1700.00, 22, 15, 'sony_srs_xb43.jpg', 'Bluetooth: Da, Vodootporan: Da, Autonomija: 24h.', '2024-11-16'),
	(617, 'JBL Flip 5', 'Komaktni bežični zvučnik s odličnim zvukom.', 900.00, 22, 20, 'jbl_flip_5.jpg', 'Bluetooth: Da, Vodootporan: Da, Autonomija: 12h.', '2024-11-16'),
	(618, 'Anker Soundcore Liberty Air 2 Pro', 'Bežične slušalice s ANC i odličnim zvukom.', 1300.00, 22, 18, 'anker_soundcore_liberty_air_2_pro.jpg', 'Bluetooth: Da, Poništavanje buke: Da, Autonomija: 8h.', '2024-11-16'),
	(619, 'Bose SoundSport Free', 'Sportske bežične slušalice s vrhunskim zvukom.', 1500.00, 22, 22, 'bose_soundsport_free.jpg', 'Bluetooth: Da, Vodootporne: Da, Autonomija: 5h.', '2024-11-16'),
	(620, 'Audio-Technica ATH-M50x', 'Profesionalne slušalice za studijsko korištenje.', 1700.00, 22, 10, 'audio_technica_ath_m50x.jpg', 'Kabelske: Da, Zatvoreni tip: Da, Frekvencijski raspon: 15-28,000 Hz.', '2024-11-16'),
	(621, 'Beats Studio3 Wireless', 'Bežične slušalice s Active Noise Cancelling (ANC).', 2300.00, 22, 13, 'beats_studio3_wireless.jpg', 'Bluetooth: Da, Poništavanje buke: Da, Autonomija: 22h.', '2024-11-16'),
	(622, 'JBL PartyBox 300', 'Bežični zvučnik za zabave.', 8000.00, 22, 4, 'jbl_partybox_300.jpg', 'Bluetooth: Da, LED svjetla: Da, Autonomija: 18h.', '2024-11-16'),
	(623, 'Logitech G Pro X Wireless', 'Gaming slušalice s bežičnom vezom i Blue Voice tehnologijom.', 1800.00, 22, 7, 'logitech_g_pro_x_wireless.jpg', 'Bluetooth: Da, Surround: Da, Autonomija: 20h.', '2024-11-16'),
	(624, 'Sennheiser HD 660S', 'Open-back slušalice za audiophile zvuk.', 3500.00, 22, 3, 'sennheiser_hd_660s.jpg', 'Kabelske: Da, Frekvencijski raspon: 10-41,000 Hz, Impedancija: 150 ohma.', '2024-11-16'),
	(625, 'Sony HT-Z9F Soundbar', 'Soundbar s Dolby Atmos tehnologijom.', 3500.00, 22, 5, 'sony_ht_z9f.jpg', 'Wi-Fi: Da, Dolby Atmos: Da, Autonomija: Neograničena (s mrežom).', '2024-11-16'),
	(626, 'Bose 700', 'Bežične slušalice s vrhunskim poništavanjem buke.', 2500.00, 22, 10, 'bose_700.jpg', 'Bluetooth: Da, Poništavanje buke: Da, Autonomija: 20h.', '2024-11-16'),
	(627, 'JBL Charge 4', 'Bežični zvučnik s dugotrajnim punjenjem.', 1300.00, 22, 18, 'jbl_charge_4.jpg', 'Bluetooth: Da, Vodootporan: Da, Autonomija: 20h.', '2024-11-16'),
	(628, 'Harman Kardon Onyx Studio 6', 'Zvučnik s elegantnim dizajnom.', 3000.00, 22, 7, 'harman_kardon_onyx_studio_6.jpg', 'Bluetooth: Da, Vodootporan: Da, Autonomija: 8h.', '2024-11-16'),
	(629, 'Beats Powerbeats Pro', 'Bežične slušalice za sport.', 2200.00, 22, 14, 'beats_powerbeats_pro.jpg', 'Bluetooth: Da, Vodootporne: Da, Autonomija: 9h.', '2024-11-16'),
	(630, 'Marshall Kilburn II', 'Bežični zvučnik s moćnim zvukom.', 2500.00, 22, 6, 'marshall_kilburn_ii.jpg', 'Bluetooth: Da, Autonomija: 20h, Vodootporan: Da.', '2024-11-16'),
	(631, 'JBL Pulse 4', 'Zvučnik s dinamičkim LED svjetlima.', 2200.00, 22, 10, 'jbl_pulse_4.jpg', 'Bluetooth: Da, Vodootporan: Da, Autonomija: 12h.', '2024-11-16'),
	(632, 'Sony HT-X8500', 'Soundbar s 2.1 kanalnim zvukom.', 2500.00, 22, 4, 'sony_ht_x8500.jpg', 'Bluetooth: Da, 4K passtrough: Da, Dolby Atmos: Da.', '2024-11-16'),
	(633, 'Sennheiser Momentum True Wireless 2', 'Bežične slušalice s odličnim zvukom i ANC.', 1500.00, 22, 8, 'sennheiser_momentum_true_wireless_2.jpg', 'Bluetooth: Da, Poništavanje buke: Da, Autonomija: 7h.', '2024-11-16'),       
	(634, 'JBL Reflect Flow', 'Sportske bežične slušalice s visokim performansama.', 1300.00, 22, 12, 'jbl_reflect_flow.jpg', 'Bluetooth: Da, Vodootporne: Da, Autonomija: 10h.', '2024-11-16'),
	(635, 'Intel Core i9-13900K', 'Najnoviji 13. generacije procesor s 24 jezgre za visoke performanse.', 4500.00, 23, 15, 'intel_i9_13900k.jpg', 'Jezgre: 24, Frekvencija: 3.0 GHz, TDP: 125W.', '2024-11-16'),
	(636, 'AMD Ryzen 9 7900X', 'Procesor visoke performanse za gaming i multitasking.', 4200.00, 23, 20, 'amd_ryzen_9_7900x.jpg', 'Jezgre: 12, Frekvencija: 4.7 GHz, TDP: 170W.', '2024-11-16'),
	(637, 'Intel Core i7-13700K', 'Performantni procesor sa 16 jezgri za gaming.', 3200.00, 23, 18, 'intel_i7_13700k.jpg', 'Jezgre: 16, Frekvencija: 3.4 GHz, TDP: 125W.', '2024-11-16'),
	(638, 'AMD Ryzen 7 7700X', 'Procesor sa 8 jezgri i odličnim odnosom cijene i performansi.', 3000.00, 23, 22, 'amd_ryzen_7_7700x.jpg', 'Jezgre: 8, Frekvencija: 4.5 GHz, TDP: 105W.', '2024-11-16'),
	(639, 'Intel Core i5-13600K', 'Odličan procesor srednje klase s 14 jezgri za gaming.', 2300.00, 23, 25, 'intel_i5_13600k.jpg', 'Jezgre: 14, Frekvencija: 3.5 GHz, TDP: 125W.', '2024-11-16'),
	(640, 'AMD Ryzen 5 5600X', 'Performantni procesor za gaming i radne stanice.', 2000.00, 23, 30, 'amd_ryzen_5_5600x.jpg', 'Jezgre: 6, Frekvencija: 3.7 GHz, TDP: 65W.', '2024-11-16'),
	(641, 'Intel Core i3-12100F', 'Pristupačan procesor za osnovne računalne zadatke.', 900.00, 23, 28, 'intel_i3_12100f.jpg', 'Jezgre: 4, Frekvencija: 3.3 GHz, TDP: 58W.', '2024-11-16'),
	(642, 'AMD Ryzen 5 7600X', 'Brzi procesor s 6 jezgri za gaming i multitasking.', 2500.00, 23, 18, 'amd_ryzen_5_7600x.jpg', 'Jezgre: 6, Frekvencija: 4.8 GHz, TDP: 105W.', '2024-11-16'),
	(643, 'Intel Core i9-12900K', 'Vrlo moćan procesor sa 16 jezgri i 24 thread-a.', 4300.00, 23, 10, 'intel_i9_12900k.jpg', 'Jezgre: 16, Frekvencija: 3.2 GHz, TDP: 125W.', '2024-11-16'),
	(644, 'AMD Ryzen 9 5900X', 'Procesor sa 12 jezgri za zahtjevne korisnike.', 3900.00, 23, 13, 'amd_ryzen_9_5900x.jpg', 'Jezgre: 12, Frekvencija: 3.7 GHz, TDP: 105W.', '2024-11-16'),
	(645, 'Intel Xeon W-2295', 'Profesionalni procesor za radne stanice s 18 jezgri.', 8000.00, 23, 6, 'intel_xeon_w_2295.jpg', 'Jezgre: 18, Frekvencija: 3.0 GHz, TDP: 165W.', '2024-11-16'),
	(646, 'AMD Threadripper 3990X', 'Ekstremno snažan procesor za radne stanice i servere.', 15000.00, 23, 2, 'amd_threadripper_3990x.jpg', 'Jezgre: 64, Frekvencija: 2.9 GHz, TDP: 280W.', '2024-11-16'),
	(647, 'Intel Core i5-12600K', 'Srednji procesor sa 10 jezgri za gaming i radne stanice.', 2200.00, 23, 19, 'intel_i5_12600k.jpg', 'Jezgre: 10, Frekvencija: 3.7 GHz, TDP: 125W.', '2024-11-16'),
	(648, 'AMD Ryzen 7 5800X', 'Gaming procesor s 8 jezgri i visokom radnom frekvencijom.', 3200.00, 23, 12, 'amd_ryzen_7_5800x.jpg', 'Jezgre: 8, Frekvencija: 4.4 GHz, TDP: 105W.', '2024-11-16'),
	(649, 'Intel Core i9-11900K', 'Snažan procesor sa 8 jezgri za gaming i multitasking.', 3500.00, 23, 7, 'intel_i9_11900k.jpg', 'Jezgre: 8, Frekvencija: 3.5 GHz, TDP: 125W.', '2024-11-16'),
	(650, 'AMD Ryzen 5 3400G', 'Pristupačan procesor s integriranim grafičkim čipom.', 1500.00, 23, 14, 'amd_ryzen_5_3400g.jpg', 'Jezgre: 4, Frekvencija: 3.7 GHz, TDP: 65W.', '2024-11-16'),
	(651, 'Intel Core i7-11700K', 'Gaming procesor sa 8 jezgri i 16 thread-a.', 3000.00, 23, 11, 'intel_i7_11700k.jpg', 'Jezgre: 8, Frekvencija: 3.6 GHz, TDP: 125W.', '2024-11-16'),
	(652, 'AMD Ryzen 9 3950X', 'Vrhunski procesor sa 16 jezgri i 32 thread-a.', 6500.00, 23, 4, 'amd_ryzen_9_3950x.jpg', 'Jezgre: 16, Frekvencija: 3.5 GHz, TDP: 105W.', '2024-11-16'),
	(653, 'Intel Core i3-10100F', 'Pristupačan procesor za osnovne aplikacije.', 850.00, 23, 23, 'intel_i3_10100f.jpg', 'Jezgre: 4, Frekvencija: 3.6 GHz, TDP: 65W.', '2024-11-16'),
	(654, 'AMD Ryzen 7 3700X', 'Vrlo dobar procesor za gaming i radne stanice.', 3000.00, 23, 18, 'amd_ryzen_7_3700x.jpg', 'Jezgre: 8, Frekvencija: 3.6 GHz, TDP: 65W.', '2024-11-16'),
	(655, 'Intel Core i5-10400F', 'Srednji procesor za gaming i osnovne aplikacije.', 1500.00, 23, 24, 'intel_i5_10400f.jpg', 'Jezgre: 6, Frekvencija: 2.9 GHz, TDP: 65W.', '2024-11-16'),
	(656, 'AMD Ryzen 9 5950X', 'Izuzetno moćan procesor za radne stanice i gaming.', 7000.00, 23, 9, 'amd_ryzen_9_5950x.jpg', 'Jezgre: 16, Frekvencija: 3.4 GHz, TDP: 105W.', '2024-11-16'),
	(657, 'Intel Core i7-10700K', 'Snažan procesor sa 8 jezgri za gaming.', 2700.00, 23, 16, 'intel_i7_10700k.jpg', 'Jezgre: 8, Frekvencija: 3.8 GHz, TDP: 125W.', '2024-11-16'),
	(658, 'AMD Ryzen 5 2600', 'Pristupačan procesor za gaming i radne stanice.', 1300.00, 23, 17, 'amd_ryzen_5_2600.jpg', 'Jezgre: 6, Frekvencija: 3.4 GHz, TDP: 95W.', '2024-11-16'),
	(659, 'Intel Xeon E-2288G', 'Profesionalni procesor za radne stanice.', 3200.00, 23, 8, 'intel_xeon_e_2288g.jpg', 'Jezgre: 8, Frekvencija: 3.7 GHz, TDP: 95W.', '2024-11-16'),
	(660, 'AMD Ryzen 3 3200G', 'Pristupačan procesor s integriranim grafičkim čipom.', 1000.00, 23, 30, 'amd_ryzen_3_3200g.jpg', 'Jezgre: 4, Frekvencija: 3.6 GHz, TDP: 65W.', '2024-11-16'),
	(661, 'Intel Core i9-11980XE', 'Ekstremni procesor za radne stanice s 18 jezgri.', 10000.00, 23, 5, 'intel_i9_11980xe.jpg', 'Jezgre: 18, Frekvencija: 3.0 GHz, TDP: 165W.', '2024-11-16'),
	(662, 'AMD Ryzen 7 3700X', 'Odličan procesor za gaming i profesionalni rad.', 2800.00, 23, 18, 'amd_ryzen_7_3700x.jpg', 'Jezgre: 8, Frekvencija: 3.6 GHz, TDP: 65W.', '2024-11-16'),
	(663, 'Intel Core i5-10600K', 'Izvrsni procesor za gaming i multimedijalne zadatke.', 1800.00, 23, 21, 'intel_i5_10600k.jpg', 'Jezgre: 6, Frekvencija: 4.1 GHz, TDP: 125W.', '2024-11-16'),
	(664, 'Epson EH-TW7100', '4K projektor s visokom svjetlinom i dinamičnim kontrastom.', 8000.00, 24, 5, 'epson_eh_tw7100.jpg', 'Rezolucija: 4K, Svjetlina: 2500 lumena, Kontrast: 100000:1.', '2024-11-16'),
	(665, 'BenQ TK850i', 'Projektor s 4K HDR i preciznim bojama za kućno kino.', 7500.00, 24, 7, 'benq_tk850i.jpg', 'Rezolucija: 4K, Svjetlina: 3000 lumena, Kontrast: 3000:1.', '2024-11-16'),
	(666, 'Optoma UHD38', 'Projektor visoke svjetline za gaming i filmove.', 6500.00, 24, 9, 'optoma_uhd38.jpg', 'Rezolucija: 4K, Svjetlina: 4000 lumena, Kontrast: 1,000,000:1.', '2024-11-16'),
	(667, 'ViewSonic PX747-4K', 'Pristupačan 4K projektor za kućno kino.', 4000.00, 24, 15, 'viewsonic_px747_4k.jpg', 'Rezolucija: 4K, Svjetlina: 3500 lumena, Kontrast: 12000:1.', '2024-11-16'),
	(668, 'LG PF50KS', 'Bežični mini projektor s Full HD rezolucijom.', 2000.00, 24, 20, 'lg_pf50ks.jpg', 'Rezolucija: 1080p, Svjetlina: 600 lumena, Kontrast: 1000:1.', '2024-11-16'),
	(669, 'Epson EF-100', 'Laser projektor s mogućnošću bežičnog povezivanja.', 5500.00, 24, 11, 'epson_ef100.jpg', 'Rezolucija: Full HD, Svjetlina: 2000 lumena, Kontrast: 250000:1.', '2024-11-16'),
	(670, 'Anker Nebula Capsule', 'Kompaktni projektor s Android operativnim sustavom.', 1500.00, 24, 25, 'anker_nebula_capsule.jpg', 'Rezolucija: 720p, Svjetlina: 100 ANSI lumena, Kontrast: 1000:1.', '2024-11-16'),
	(671, 'XGIMI Horizon Pro', '4K projektor s Android TV platformom i Dolby Atmos zvukom.', 6500.00, 24, 8, 'xgimi_horizon_pro.jpg', 'Rezolucija: 4K, Svjetlina: 2200 lumena, Kontrast: 12000:1.', '2024-11-16'),
	(672, 'Epson Home Cinema 5050UB', 'Projektor za kućno kino s HDR podrškom i 4K.', 8000.00, 24, 12, 'epson_home_cinema_5050ub.jpg', 'Rezolucija: 4K, Svjetlina: 2600 lumena, Kontrast: 1,000,000:1.', '2024-11-16'),
	(673, 'BenQ HT3550', 'Projektor s visokim kontrastom i preciznim bojama.', 4000.00, 24, 14, 'benq_ht3550.jpg', 'Rezolucija: 4K, Svjetlina: 2000 lumena, Kontrast: 3000:1.', '2024-11-16'),
	(674, 'ViewSonic PX706HD', 'Kratkoročni projektor s Full HD rezolucijom i 3000 lumena.', 2800.00, 24, 22, 'viewsonic_px706hd.jpg', 'Rezolucija: 1080p, Svjetlina: 3000 lumena, Kontrast: 22000:1.', '2024-11-16'),
	(675, 'Epson EB-U05', 'Projektor s 3LCD tehnologijom i Full HD rezolucijom.', 2500.00, 24, 18, 'epson_eb_u05.jpg', 'Rezolucija: Full HD, Svjetlina: 3300 lumena, Kontrast: 15000:1.', '2024-11-16'),
	(676, 'LG HU70LA', '4K projektor s LED tehnologijom za kućno kino.', 6000.00, 24, 10, 'lg_hu70la.jpg', 'Rezolucija: 4K, Svjetlina: 1500 lumena, Kontrast: 15000:1.', '2024-11-16'),
	(677, 'Kodak Luma 350', 'Mini projektor sa 350 lumena i Android sistemom.', 1200.00, 24, 30, 'kodak_luma_350.jpg', 'Rezolucija: 720p, Svjetlina: 350 lumena, Kontrast: 1000:1.', '2024-11-16'),
	(678, 'Epson EB-L630SU', 'Laser projektor visoke svjetline za profesionalne prostorije.', 10000.00, 24, 3, 'epson_eb_l630su.jpg', 'Rezolucija: WUXGA, Svjetlina: 6000 lumena, Kontrast: 2000000:1.', '2024-11-16'),
	(679, 'ViewSonic M1 Mini Plus', 'Mini projektor s bežičnim mogućnostima i Android aplikacijama.', 1500.00, 24, 16, 'viewsonic_m1_mini_plus.jpg', 'Rezolucija: 720p, Svjetlina: 250 lumena, Kontrast: 1000:1.', '2024-11-16'),       
	(680, 'Optoma GT1080HDR', 'Projektor s Full HD i HDR podrškom za gaming.', 3000.00, 24, 13, 'optoma_gt1080hdr.jpg', 'Rezolucija: 1080p, Svjetlina: 3800 lumena, Kontrast: 50000:1.', '2024-11-16'),
	(681, 'Anker Nebula Cosmos Max', 'Projektor s 4K i 3600 lumena svjetline za kućno kino.', 6500.00, 24, 7, 'anker_nebula_cosmos_max.jpg', 'Rezolucija: 4K, Svjetlina: 3600 lumena, Kontrast: 15000:1.', '2024-11-16'),
	(682, 'LG PF50KA', 'Bežični projektor s Full HD i dužim trajanjem baterije.', 2500.00, 24, 20, 'lg_pf50ka.jpg', 'Rezolucija: Full HD, Svjetlina: 600 lumena, Kontrast: 1000:1.', '2024-11-16'),
	(683, 'Epson EB-X41', 'Projektor s XGA rezolucijom za poslovnu i obrazovnu upotrebu.', 2200.00, 24, 23, 'epson_eb_x41.jpg', 'Rezolucija: XGA, Svjetlina: 3300 lumena, Kontrast: 15000:1.', '2024-11-16'),
	(684, 'XGIMI MoGo Pro+', 'Mini projektor s Android TV i 4K HDR podrškom.', 3500.00, 24, 9, 'xgimi_mogo_pro.jpg', 'Rezolucija: 1080p, Svjetlina: 300 lumena, Kontrast: 1000:1.', '2024-11-16'),
	(685, 'BenQ GS2', 'Projektor otporan na vodu i prašinu za vanjsku uporabu.', 3000.00, 24, 18, 'benq_gs2.jpg', 'Rezolucija: 1080p, Svjetlina: 500 lumena, Kontrast: 10000:1.', '2024-11-16'),
	(686, 'Optoma UHZ65', 'Laser projektor s 4K rezolucijom i dugovječnošću svjetla.', 12000.00, 24, 4, 'optoma_uhz65.jpg', 'Rezolucija: 4K, Svjetlina: 3000 lumena, Kontrast: 2000000:1.', '2024-11-16'),
	(687, 'Epson LS500', 'Projektor s 4K i laser tehnologijom za kućno kino.', 11000.00, 24, 2, 'epson_ls500.jpg', 'Rezolucija: 4K, Svjetlina: 4000 lumena, Kontrast: 2000000:1.', '2024-11-16'),
	(688, 'LG CineBeam HU85LA', 'Ultra kratkotrajni projektor s 4K i HDR.', 10000.00, 24, 3, 'lg_cinebeam_hu85la.jpg', 'Rezolucija: 4K, Svjetlina: 2700 lumena, Kontrast: 15000:1.', '2024-11-16'),
	(689, 'ViewSonic PX748-4K', 'Projektor za kućno kino s 4K rezolucijom.', 7000.00, 24, 10, 'viewsonic_px748_4k.jpg', 'Rezolucija: 4K, Svjetlina: 3200 lumena, Kontrast: 12000:1.', '2024-11-16'),
	(690, 'Epson EF-100', 'Bežični projektor za kvalitetne filmove na svim površinama.', 5500.00, 24, 6, 'epson_ef_100.jpg', 'Rezolucija: Full HD, Svjetlina: 2000 lumena, Kontrast: 250000:1.', '2024-11-16'),
	(691, 'Razer Kraken V3', 'Gaming slušalice s RGB pozadinskim osvjetljenjem i Dolby Sound.', 1200.00, 25, 10, 'razer_kraken_v3.jpg', 'Tip: Over-ear, Zvuk: 7.1 surround, Osvjetljenje: RGB.', '2024-11-16'),
	(692, 'Logitech G Pro X', 'Gaming slušalice s Blue VO!CE tehnologijom za jasan zvuk.', 1500.00, 25, 8, 'logitech_g_pro_x.jpg', 'Tip: Over-ear, Zvuk: 7.1 surround, Mikrofoni: Blue VO!CE.', '2024-11-16'),
	(693, 'Corsair K95 RGB Platinum', 'Gaming tipkovnica s mehaničkim tipkama i RGB osvjetljenjem.', 2500.00, 25, 12, 'corsair_k95_rgb_platinum.jpg', 'Tip: Mehanička, Osvjetljenje: RGB, Tipke: Cherry MX.', '2024-11-16'),
	(694, 'SteelSeries Rival 600', 'Gaming miš s dvostrukim senzorima za preciznost i brzinu.', 900.00, 25, 15, 'steelseries_rival_600.jpg', 'Tip: Optički, Senzori: TrueMove3, Osvjetljenje: RGB.', '2024-11-16'),
	(695, 'Logitech G923', 'Trkaći volan s TrueForce tehnologijom za bolju povratnu informaciju.', 3500.00, 25, 5, 'logitech_g923.jpg', 'Tip: Volan, Povratna informacija: TrueForce, Kompatibilnost: PC, PlayStation, Xbox.', '2024-11-16'),
	(696, 'Razer Huntsman Elite', 'Gaming tipkovnica s optičkim prekidačima i mehaničkim tipkama.', 2800.00, 25, 11, 'razer_huntsman_elite.jpg', 'Tip: Optička, Tipke: Razer Linear Optical, Osvjetljenje: RGB.', '2024-11-16'),
	(697, 'SteelSeries Arctis 7', 'Bežične gaming slušalice s CrystalClear zvukom i dugotrajnim baterijama.', 1600.00, 25, 6, 'steelseries_arctis_7.jpg', 'Tip: Bežične, Zvuk: 7.1 surround, Baterija: 24h.', '2024-11-16'),
	(698, 'Logitech G502 Hero', 'Gaming miš s preciznim senzorom Hero i programabilnim tipkama.', 900.00, 25, 14, 'logitech_g502_hero.jpg', 'Tip: Optički, Senzor: Hero 16K, Osvjetljenje: RGB.', '2024-11-16'),
	(699, 'Corsair Void RGB Elite', 'Bežične gaming slušalice s bogatim zvukom i dugotrajnim udobnostima.', 1400.00, 25, 9, 'corsair_void_rgb_elite.jpg', 'Tip: Bežične, Zvuk: 7.1 surround, Osvjetljenje: RGB.', '2024-11-16'),        
	(700, 'Razer DeathAdder Elite', 'Gaming miš s ergonomskim dizajnom i preciznim senzorom.', 700.00, 25, 20, 'razer_deathadder_elite.jpg', 'Tip: Optički, Senzor: 16,000 DPI, Osvjetljenje: RGB.', '2024-11-16'),
	(701, 'HyperX Alloy FPS Pro', 'Kompaktna gaming tipkovnica s mehaničkim prekidačima.', 1600.00, 25, 18, 'hyperx_alloy_fps_pro.jpg', 'Tip: Mehanička, Tipke: Cherry MX, Kompaktna.', '2024-11-16'),
	(702, 'Corsair K70 RGB MK.2', 'Gaming tipkovnica s Cherry MX prekidačima i RGB osvjetljenjem.', 2200.00, 25, 7, 'corsair_k70_rgb_mk2.jpg', 'Tip: Mehanička, Tipke: Cherry MX, Osvjetljenje: RGB.', '2024-11-16'),
	(703, 'Logitech G915 Lightspeed', 'Bežična gaming tipkovnica s ultra tankim dizajnom.', 3500.00, 25, 5, 'logitech_g915_lightspeed.jpg', 'Tip: Mehanička, Bežična, Osvjetljenje: RGB.', '2024-11-16'),
	(704, 'Turtle Beach Stealth 600 Gen 2', 'Bežične gaming slušalice za PlayStation s kvalitetnim zvukom.', 1200.00, 25, 13, 'turtle_beach_stealth_600_gen_2.jpg', 'Tip: Bežične, Zvuk: 7.1 surround, Kompatibilnost: PlayStation.', '2024-11-16'),
	(705, 'Razer Nari Ultimate', 'Gaming slušalice s haptikom i 7.1 surround zvukom.', 2200.00, 25, 8, 'razer_nari_ultimate.jpg', 'Tip: Bežične, Zvuk: 7.1 surround, Haptika: Razer HyperSense.', '2024-11-16'),
	(706, 'SteelSeries Apex Pro', 'Gaming tipkovnica s podesivim mehaničkim prekidačima i RGB osvjetljenjem.', 3500.00, 25, 4, 'steelseries_apex_pro.jpg', 'Tip: Mehanička, Prekidači: OmniPoint, Osvjetljenje: RGB.', '2024-11-16'),
	(707, 'Logitech G930', 'Bežične gaming slušalice s 7.1 surround zvukom i dugotrajnim baterijama.', 1800.00, 25, 12, 'logitech_g930.jpg', 'Tip: Bežične, Zvuk: 7.1 surround, Baterija: 12h.', '2024-11-16'),
	(708, 'Corsair Scimitar RGB Elite', 'Gaming miš s 17 programabilnih tipki za MMO igre.', 1400.00, 25, 10, 'corsair_scimitar_rgb_elite.jpg', 'Tip: Optički, Tipke: 17, Osvjetljenje: RGB.', '2024-11-16'),
	(709, 'SteelSeries Rival 310', 'Gaming miš s ergonomskim dizajnom i visokim DPI senzorom.', 1000.00, 25, 14, 'steelseries_rival_310.jpg', 'Tip: Optički, Senzor: TrueMove3, DPI: 12000.', '2024-11-16'),
	(710, 'Razer BlackWidow V3', 'Mehanička gaming tipkovnica s Razer Green prekidačima.', 2200.00, 25, 11, 'razer_blackwidow_v3.jpg', 'Tip: Mehanička, Tipke: Razer Green, Osvjetljenje: RGB.', '2024-11-16'),
	(711, 'Logitech G413', 'Mehanička gaming tipkovnica s Romer-G prekidačima i čvrstim aluminijskim okvirom.', 1600.00, 25, 15, 'logitech_g413.jpg', 'Tip: Mehanička, Prekidači: Romer-G, Osvjetljenje: Bijelo.', '2024-11-16'),       
	(712, 'Tritton Kunai 7.1', 'Gaming slušalice s 7.1 surround zvukom i mogućnostima prilagodbe.', 1300.00, 25, 9, 'tritton_kunai_71.jpg', 'Tip: Bežične, Zvuk: 7.1 surround, Kompatibilnost: PC, PlayStation, Xbox.', '2024-11-16'),  
	(713, 'Corsair Harpoon RGB Wireless', 'Bežični gaming miš s 6 programabilnih tipki i RGB osvjetljenjem.', 800.00, 25, 17, 'corsair_harpoon_rgb_wireless.jpg', 'Tip: Bežični, Osvjetljenje: RGB, Tipke: 6.', '2024-11-16'),
	(714, 'Razer Mamba Elite', 'Gaming miš s ergonomskim dizajnom i visokim performansama.', 1200.00, 25, 10, 'razer_mamba_elite.jpg', 'Tip: Optički, DPI: 16,000, Osvjetljenje: RGB.', '2024-11-16'),
	(715, 'SteelSeries Apex 7', 'Mehanička gaming tipkovnica s RGB i dugovječnošću.', 2500.00, 25, 8, 'steelseries_apex_7.jpg', 'Tip: Mehanička, Prekidači: SteelSeries, Osvjetljenje: RGB.', '2024-11-16'),
	(716, 'Turtle Beach Recon 200', 'Gaming slušalice s pojačalom i poboljšanim basovima.', 900.00, 25, 18, 'turtle_beach_recon_200.jpg', 'Tip: On-ear, Zvuk: 40mm, Kompatibilnost: PC, PlayStation, Xbox.', '2024-11-16'),
	(717, 'Oculus Quest 2', 'Samostalni VR uređaj s visokokvalitetnim ekranom i bez računala.', 3000.00, 26, 15, 'oculus_quest_2.jpg', 'Rezolucija: 1832x1920 po oku, 6DoF, Bežični.', '2024-11-16'),
	(718, 'HTC Vive Pro 2', 'VR headset za profesionalnu upotrebu s 5K rezolucijom.', 6000.00, 26, 8, 'htc_vive_pro_2.jpg', 'Rezolucija: 2448x2448 po oku, 120Hz, 5K.', '2024-11-16'),
	(719, 'PlayStation VR2', 'Virtualna stvarnost za PlayStation 5 s naprednim funkcijama.', 4500.00, 26, 10, 'playstation_vr2.jpg', 'Rezolucija: 2000x2040 po oku, Kompatibilnost: PS5.', '2024-11-16'),
	(720, 'Valve Index', 'Visoko kvalitetni VR headset s širokim vidnim poljem.', 7500.00, 26, 5, 'valve_index.jpg', 'Rezolucija: 1440x1600 po oku, 120Hz, 130° FOV.', '2024-11-16'),
	(721, 'Oculus Rift S', 'VR uređaj s prilagodljivim strapovima za bolju udobnost.', 2500.00, 26, 12, 'oculus_rift_s.jpg', 'Rezolucija: 1280x1440 po oku, 80Hz, Kompatibilnost: PC.', '2024-11-16'),
	(722, 'Pico Neo 3', 'Bežični VR headset za visoke performanse i dugotrajno igranje.', 3500.00, 26, 6, 'pico_neo_3.jpg', 'Rezolucija: 3664x1920, 90Hz, 6DoF.', '2024-11-16'),
	(723, 'HP Reverb G2', 'Visoko rezolucijski VR headset za simulacije i profesionalnu upotrebu.', 8000.00, 26, 4, 'hp_reverb_g2.jpg', 'Rezolucija: 2160x2160 po oku, 90Hz, 114° FOV.', '2024-11-16'),
	(724, 'Lenovo Mirage Solo', 'Autonomni VR uređaj za jednostavnu upotrebu i pristupačnost.', 2000.00, 26, 18, 'lenovo_mirage_solo.jpg', 'Rezolucija: 2560x1440, 75Hz, Kompatibilnost: Bežično.', '2024-11-16'),
	(725, 'Samsung Odyssey+', 'AMOLED VR headset s visokom razlučivošću za intenzivne igre.', 4000.00, 26, 9, 'samsung_odyssey_plus.jpg', 'Rezolucija: 2880x1600, 90Hz, AMOLED.', '2024-11-16'),
	(726, 'Vive Cosmos Elite', 'VR headset s preciznim praćenjem i ugrađenim slušalicama.', 5500.00, 26, 7, 'vive_cosmos_elite.jpg', 'Rezolucija: 2880x1700 po oku, 90Hz, Kompatibilnost: PC.', '2024-11-16'),
	(727, 'Oculus Link Cable', 'USB-C kabel za povezivanje Oculus Quest s računalom.', 300.00, 26, 20, 'oculus_link_cable.jpg', 'Dužina: 5m, Kompatibilnost: Oculus Quest, PC.', '2024-11-16'),
	(728, 'Oculus Touch Kontroleri', 'Ergonomski VR kontroleri za precizno upravljanje igrama.', 1000.00, 26, 15, 'oculus_touch_kontroleri.jpg', 'Tip: Bežični, Kompatibilnost: Oculus Quest.', '2024-11-16'),
	(729, 'Vive Trackers', 'Praćenje pokreta za dodatnu preciznost u VR iskustvima.', 1200.00, 26, 5, 'vive_trackers.jpg', 'Kompatibilnost: HTC Vive, Komplet: 3 trackers.', '2024-11-16'),
	(730, 'PSVR Aim Controller', 'Specijalizirani kontroler za VR igre s preciznim ciljanjem.', 900.00, 26, 11, 'psvr_aim_controller.jpg', 'Kompatibilnost: PlayStation VR, Bežični.', '2024-11-16'),
	(731, 'Vive Pro Audio Strap', 'Slušalice i headset s poboljšanom udobnošću za HTC Vive Pro.', 1800.00, 26, 8, 'vive_pro_audio_strap.jpg', 'Kompatibilnost: HTC Vive Pro, Podesiv, Integrirani zvuk.', '2024-11-16'),
	(732, 'Oculus Quest 2 Elite Strap', 'Podesiv remen za veću udobnost tijekom VR iskustava.', 600.00, 26, 16, 'oculus_quest_2_elite_strap.jpg', 'Kompatibilnost: Oculus Quest 2, Podesivo, Udobno.', '2024-11-16'),
	(733, 'Oculus Quest 2 Fit Pack', 'Dodatna oprema za bolju udobnost i podešavanje Oculus Quest 2.', 400.00, 26, 12, 'oculus_quest_2_fit_pack.jpg', 'Kompatibilnost: Oculus Quest 2, Udobnost: Silikonski poklopci.', '2024-11-16'),
	(734, 'Pico Neo 2 Eye', 'VR headset s prilagođenim praćenjem očiju za vrhunske performanse.', 6500.00, 26, 6, 'pico_neo_2_eye.jpg', 'Rezolucija: 3664x1920, 90Hz, Eye-tracking.', '2024-11-16'),
	(735, 'HTC Vive Wireless Adapter', 'Bežični adapter za HTC Vive kako bi se eliminirali kablovi.', 2500.00, 26, 7, 'htc_vive_wireless_adapter.jpg', 'Kompatibilnost: HTC Vive, Bežični.', '2024-11-16'),
	(736, 'Oculus Rift S Carrying Case', 'Zaštitna torba za Oculus Rift S VR headset.', 400.00, 26, 15, 'oculus_rift_s_carrying_case.jpg', 'Kompatibilnost: Oculus Rift S, Materijal: EVA.', '2024-11-16'),
	(737, 'The Witcher 3: Wild Hunt', 'Akcijska RPG igra smještena u fantastičnom svijetu.', 350.00, 28, 25, 'the_witcher_3.jpg', 'Žanr: RPG, Platforme: PC, PS4, Xbox.', '2024-11-16'),
	(738, 'Red Dead Redemption 2', 'Pustolovna igra smještena u Divlji zapad.', 450.00, 28, 30, 'red_dead_redemption_2.jpg', 'Žanr: Akcija, Platforme: PC, PS4, Xbox.', '2024-11-16'),
	(739, 'Cyberpunk 2077', 'Sci-fi RPG u futurističkom okruženju.', 400.00, 28, 20, 'cyberpunk_2077.jpg', 'Žanr: RPG, Platforme: PC, PS5, Xbox Series X.', '2024-11-16'),
	(740, 'Minecraft', 'Popularna sandbox igra za gradnju i preživljavanje.', 250.00, 28, 40, 'minecraft.jpg', 'Žanr: Sandbox, Platforme: PC, PS4, Xbox, Switch.', '2024-11-16'),
	(741, 'GTA V', 'Akcijska avantura smještena u otvorenom svijetu.', 350.00, 28, 35, 'gta_v.jpg', 'Žanr: Akcija, Platforme: PC, PS4, Xbox.', '2024-11-16'),
	(742, 'FIFA 23', 'Najnoviji nastavak popularnog nogometnog serijala.', 300.00, 28, 50, 'fifa_23.jpg', 'Žanr: Sportska simulacija, Platforme: PC, PS5, Xbox Series X.', '2024-11-16'),
	(743, 'Call of Duty: Modern Warfare II', 'Akcijska pucačina iz prvog lica.', 400.00, 28, 20, 'call_of_duty_mw2.jpg', 'Žanr: FPS, Platforme: PC, PS4, Xbox.', '2024-11-16'),
	(744, 'The Elder Scrolls V: Skyrim', 'RPG igra u otvorenom svijetu s bogatom pričom.', 350.00, 28, 15, 'skyrim.jpg', 'Žanr: RPG, Platforme: PC, PS4, Xbox, Switch.', '2024-11-16'),
	(745, "Assassin's Creed Valhalla", 'Akcijska avantura smještena u vikinško doba.', 500.00, 28, 22, 'assassins_creed_valhalla.jpg', 'Žanr: Akcija, Platforme: PC, PS5, Xbox Series X.', '2024-11-16'),
	(746, 'Horizon Zero Dawn', 'Akcijska avantura smještena u post-apokaliptični svijet.', 450.00, 28, 18, 'horizon_zero_dawn.jpg', 'Žanr: Akcija, Platforme: PS4, PC.', '2024-11-16'),
	(747, 'Battlefield 2042', 'Pucačina s futurističkim ratovima i velikim bojištima.', 400.00, 28, 28, 'battlefield_2042.jpg', 'Žanr: FPS, Platforme: PC, PS5, Xbox Series X.', '2024-11-16'),
	(748, "Sid Meier's Civilization VI", 'Strategijska igra u kojoj igrač vodi svoju civilizaciju do svjetske dominacije.', 350.00, 28, 25, 'civilization_vi.jpg', 'Žanr: Strategija, Platforme: PC, Switch, PS4, Xbox.', '2024-11-16'),(749, 'The Legend of Zelda: Breath of the Wild', 'Akcijska avantura u otvorenom svijetu s puzzle elementima.', 500.00, 28, 30, 'zelda_breath_of_the_wild.jpg', 'Žanr: Akcija, Platforme: Switch.', '2024-11-16'),
	(750, 'Monster Hunter: World', 'Akcijska igra u kojoj igrač lovi ogromne zvijeri.', 400.00, 28, 25, 'monster_hunter_world.jpg', 'Žanr: Akcija, Platforme: PC, PS4, Xbox.', '2024-11-16'),
	(751, 'Among Us', 'Popularna multiplayer društvena igra u kojoj se mora otkriti tko je imposter.', 150.00, 28, 50, 'among_us.jpg', 'Žanr: Party, Platforme: PC, Switch, Mobile.', '2024-11-16'),
	(752, 'Watch Dogs: Legion', 'Akcijska avantura u kojoj se igrač bori protiv korupcije u Londonu.', 400.00, 28, 19, 'watch_dogs_legion.jpg', 'Žanr: Akcija, Platforme: PC, PS4, Xbox.', '2024-11-16'),
	(753, 'The Sims 4', 'Simulacijska igra u kojoj igrač kontrolira virtualne likove.', 300.00, 28, 35, 'the_sims_4.jpg', 'Žanr: Simulacija, Platforme: PC, PS4, Xbox.', '2024-11-16'),
	(754, 'Red Dead Redemption', 'Prequel RDR2 smješten u Divlji zapad.', 350.00, 28, 30, 'red_dead_redemption.jpg', 'Žanr: Akcija, Platforme: PS3, Xbox 360.', '2024-11-16'),
	(755, 'Tomb Raider', 'Akcijska avantura u kojoj igrač preživljava opasne situacije kao Lara Croft.', 350.00, 28, 18, 'tomb_raider.jpg', 'Žanr: Akcija, Platforme: PC, PS4, Xbox.', '2024-11-16'),
	(756, 'Minecraft Dungeons', 'Akcijska avantura u Minecraft svijetu.', 250.00, 28, 20, 'minecraft_dungeons.jpg', 'Žanr: Akcija, Platforme: PC, PS4, Xbox, Switch.', '2024-11-16'),
	(757, 'F1 2023', 'Simulacija Formule 1 s realističnim prikazom utrka.', 450.00, 28, 22, 'f1_2023.jpg', 'Žanr: Sportska simulacija, Platforme: PC, PS5, Xbox Series X.', '2024-11-16'),
	(758, 'Far Cry 6', 'Akcijska avantura smještena u fikcionalnu tropsku zemlju.', 400.00, 28, 19, 'far_cry_6.jpg', 'Žanr: Akcija, Platforme: PC, PS5, Xbox Series X.', '2024-11-16'),
	(759, 'Spiderman: Miles Morales', 'Akcijska avantura u kojoj igrač preuzima ulogu Spider-Mana Milesa Moralesa.', 450.00, 28, 25, 'spiderman_miles_morales.jpg', 'Žanr: Akcija, Platforme: PS5, PS4.', '2024-11-16'),
	(760, 'Sekiro: Shadows Die Twice', 'Akcijska avantura u kojoj igrač istražuje Japan u feudalnom razdoblju.', 500.00, 28, 23, 'sekiro_shadows_die_twice.jpg', 'Žanr: Akcija, Platforme: PC, PS4, Xbox.', '2024-11-16'),
	(761, 'Star Wars Jedi: Fallen Order', 'Akcijska avantura smještena u Star Wars svemir.', 400.00, 28, 30, 'star_wars_jedi_fallen_order.jpg', 'Žanr: Akcija, Platforme: PC, PS4, Xbox.', '2024-11-16'),
	(762, 'Need for Speed Heat', 'Racing igra s naglaskom na ulicu i ilegalne utrke.', 350.00, 28, 30, 'need_for_speed_heat.jpg', 'Žanr: Racing, Platforme: PC, PS4, Xbox.', '2024-11-16'),
	(763, 'Borderlands 3', 'Kooperativna pucačina u otvorenom svijetu s RPG elementima.', 400.00, 28, 28, 'borderlands_3.jpg', 'Žanr: FPS, Platforme: PC, PS4, Xbox.', '2024-11-16'),
	(764, 'Dead by Daylight', 'Asimetrična horor multiplayer igra u kojoj jedan igrač lovi ostale.', 250.00, 28, 35, 'dead_by_daylight.jpg', 'Žanr: Horor, Platforme: PC, PS4, Xbox.', '2024-11-16'),
	(765, 'Apple Watch Series 8', 'Pametan sat s funkcijama praćenja zdravlja i fitnessa.', 3000.00, 29, 15, 'apple_watch_series_8.jpg', 'Zaslon: Retina, OS: watchOS, Baterija: do 18 sati.', '2024-11-16'),
	(766, 'Samsung Galaxy Watch 6', 'Pametan sat sa senzorima za praćenje fitnessa i zdravlja.', 2500.00, 29, 20, 'samsung_galaxy_watch_6.jpg', 'Zaslon: Super AMOLED, OS: WearOS, Baterija: do 40 sati.', '2024-11-16'),
	(767, 'Garmin Venu 2', 'Pametan sat za sportaše sa senzorima za praćenje aktivnosti.', 2000.00, 29, 18, 'garmin_venu_2.jpg', 'Zaslon: AMOLED, OS: Garmin OS, Baterija: do 11 dana.', '2024-11-16'),
	(768, 'Fitbit Sense 2', 'Pametan sat s funkcijama za praćenje zdravlja i stresa.', 1500.00, 29, 22, 'fitbit_sense_2.jpg', 'Zaslon: AMOLED, OS: Fitbit OS, Baterija: do 6 dana.', '2024-11-16'),
	(769, 'Amazfit GTR 4', 'Pametan sat s dugim trajanjem baterije i senzorima za zdravlje.', 1800.00, 29, 25, 'amazfit_gtr_4.jpg', 'Zaslon: AMOLED, OS: Zepp OS, Baterija: do 14 dana.', '2024-11-16'),
	(770, 'Huawei Watch GT 3', 'Pametan sat s funkcijama za praćenje fitnessa i zdravlja.', 2000.00, 29, 20, 'huawei_watch_gt_3.jpg', 'Zaslon: AMOLED, OS: HarmonyOS, Baterija: do 14 dana.', '2024-11-16'),
	(771, 'Withings Steel HR Sport', 'Pametan sat s klasičnim izgledom i funkcijama za praćenje aktivnosti.', 1500.00, 29, 30, 'withings_steel_hr_sport.jpg', 'Zaslon: OLED, OS: Withings OS, Baterija: do 25 dana.', '2024-11-16'),    
	(772, 'Polar Vantage V2', 'Pametan sat za sportaše sa naprednim funkcijama za praćenje performansi.', 3500.00, 29, 18, 'polar_vantage_v2.jpg', 'Zaslon: MIP, OS: Polar OS, Baterija: do 7 dana.', '2024-11-16'),
	(773, 'Suunto 9 Peak', 'Pametan sat za sportaše s preciznim senzorima za praćenje aktivnosti.', 4000.00, 29, 15, 'suunto_9_peak.jpg', 'Zaslon: AMOLED, OS: Suunto OS, Baterija: do 25 sati.', '2024-11-16'),
	(774, 'TicWatch Pro 3', 'Pametan sat s dualnim zaslonom i dugotrajnim trajanjem baterije.', 2300.00, 29, 25, 'ticwatch_pro_3.jpg', 'Zaslon: AMOLED, OS: WearOS, Baterija: do 72 sata.', '2024-11-16'),
	(775, 'Creality Ender 3 V2', 'Popularni 3D pisač s velikim volumenom printanja.', 2200.00, 30, 25, 'creality_ender_3_v2.jpg', 'Tip: FDM, Volumen: 220x220x250 mm, Brzina: 180mm/s.', '2024-11-16'),
	(776, 'Prusa i3 MK3S+', 'Visokokvalitetni 3D pisač s naprednim funkcijama.', 8000.00, 30, 15, 'prusa_i3_mk3s.jpg', 'Tip: FDM, Volumen: 250x210x210 mm, Brzina: 200mm/s.', '2024-11-16'),
	(777, 'Anycubic Vyper', 'Brzi i precizni 3D pisač s automatskim niveliranjem.', 2500.00, 30, 20, 'anycubic_vyper.jpg', 'Tip: FDM, Volumen: 245x245x260 mm, Brzina: 100mm/s.', '2024-11-16'),
	(778, 'Artillery Sidewinder X1', 'Pisač s velikim volumenom printanja i naprednim značajkama.', 3500.00, 30, 30, 'artillery_sidewinder_x1.jpg', 'Tip: FDM, Volumen: 300x300x400 mm, Brzina: 150mm/s.', '2024-11-16'),
	(779, 'Elegoo Mars 2 Pro', 'Stereolitografski 3D pisač za preciznu proizvodnju.', 2500.00, 30, 25, 'elegoo_mars_2_pro.jpg', 'Tip: SLA, Volumen: 129x80x160 mm, Brzina: 50mm/h.', '2024-11-16'),
	(780, 'Anycubic Photon Mono X', 'UV resin printer za visoku preciznost 3D ispisa.', 3000.00, 30, 20, 'anycubic_photon_mono_x.jpg', 'Tip: SLA, Volumen: 192x120x245 mm, Brzina: 60mm/h.', '2024-11-16'),
	(781, 'Bambulab X1', 'Visoko precizni 3D pisač za profesionalne korisnike.', 9000.00, 30, 15, 'bambulab_x1.jpg', 'Tip: FDM, Volumen: 256x256x256 mm, Brzina: 180mm/s.', '2024-11-16'),
	(782, 'Elegoo Neptune 2S', 'Pisač sa stabilnim performansama i povoljnim cijenama.', 1800.00, 30, 30, 'elegoo_neptune_2s.jpg', 'Tip: FDM, Volumen: 220x220x250 mm, Brzina: 150mm/s.', '2024-11-16'),
	(783, 'FlashForge Adventurer 3', 'Kompaktni 3D pisač s automatskim niveliranjem i Wi-Fi povezivanjem.', 4000.00, 30, 20, 'flashforge_adventurer_3.jpg', 'Tip: FDM, Volumen: 150x150x150 mm, Brzina: 100mm/s.', '2024-11-16'),       
	(784, 'Raise3D Pro2', 'Visokokvalitetni 3D pisač za profesionalce i industrijske primjene.', 15000.00, 30, 10, 'raise3d_pro2.jpg', 'Tip: FDM, Volumen: 305x305x300 mm, Brzina: 150mm/s.', '2024-11-16'),
	(785, 'Voxelab Aquila X2', 'Odličan 3D pisač za početnike s velikim volumenom printanja.', 2200.00, 30, 28, 'voxelab_aquila_x2.jpg', 'Tip: FDM, Volumen: 220x220x250 mm, Brzina: 180mm/s.', '2024-11-16'),
	(786, 'Creality CR-10', 'Popularni pisač za DIY projekte s velikim volumenom printanja.', 3500.00, 30, 25, 'creality_cr_10.jpg', 'Tip: FDM, Volumen: 300x300x400 mm, Brzina: 150mm/s.', '2024-11-16'),
	(787, 'Snapmaker 2.0 A350', 'Svestrani 3D pisač koji podržava i lasersko graviranje.', 8500.00, 30, 18, 'snapmaker_2.0_a350.jpg', 'Tip: FDM, Volumen: 320x350x330 mm, Brzina: 200mm/s.', '2024-11-16'),
	(788, 'FDM-Tek', 'Pisač s naprednim funkcijama za preciznu proizvodnju.', 7000.00, 30, 12, 'fdm_tek.jpg', 'Tip: FDM, Volumen: 250x250x250 mm, Brzina: 180mm/s.', '2024-11-16'),
	(789, 'Prusa Mini+', 'Kompatibilni 3D pisač s odličnim performansama i jednostavnim postavljanjem.', 4500.00, 30, 30, 'prusa_mini_plus.jpg', 'Tip: FDM, Volumen: 180x180x180 mm, Brzina: 200mm/s.', '2024-11-16'),
	(790, 'Polaroid PlaySmart', 'Jednostavan 3D pisač za kućnu upotrebu.', 1500.00, 30, 25, 'polaroid_playsmart.jpg', 'Tip: FDM, Volumen: 110x110x120 mm, Brzina: 90mm/s.', '2024-11-16'),
	(791, 'Monoprice Voxel', 'Kompaktni 3D pisač s jednostavnom instalacijom i upotrebom.', 2200.00, 30, 27, 'monoprice_voxel.jpg', 'Tip: FDM, Volumen: 120x120x120 mm, Brzina: 100mm/s.', '2024-11-16'),
	(792, 'LulzBot Mini 2', 'Pisač za napredne korisnike s visokom preciznošću.', 6000.00, 30, 20, 'lulzbot_mini_2.jpg', 'Tip: FDM, Volumen: 160x160x180 mm, Brzina: 150mm/s.', '2024-11-16'),
	(793, 'Zortrax M200 Plus', 'Visokokvalitetni 3D pisač za profesionalne primjene.', 10000.00, 30, 18, 'zortrax_m200_plus.jpg', 'Tip: FDM, Volumen: 200x200x200 mm, Brzina: 150mm/s.', '2024-11-16'),
	(794, 'Anycubic Chiron', 'Pisač s velikim volumenom printanja i visokim kvalitetom.', 3500.00, 30, 25, 'anycubic_chiron.jpg', 'Tip: FDM, Volumen: 400x400x450 mm, Brzina: 180mm/s.', '2024-11-16'),
	(795, 'Kossel Delta', 'Delta 3D pisač s visokom preciznošću.', 3000.00, 30, 20, 'kossel_delta.jpg', 'Tip: Delta, Volumen: 230x230x300 mm, Brzina: 180mm/s.', '2024-11-16'),
	(796, 'BCN3D Sigma D25', 'Profesionalni 3D pisač za industrijsku proizvodnju.', 11000.00, 30, 15, 'bcn3d_sigma_d25.jpg', 'Tip: FDM, Volumen: 420x300x210 mm, Brzina: 200mm/s.', '2024-11-16'),
	(797, 'Flsun Q5', 'Delta 3D pisač s velikim volumenom i brzim ispisom.', 3500.00, 30, 20, 'flsun_q5.jpg', 'Tip: Delta, Volumen: 260x260x330 mm, Brzina: 180mm/s.', '2024-11-16'),
	(798, 'Tevo Tornado', 'Ekonomičan 3D pisač za kućnu proizvodnju.', 2500.00, 30, 25, 'tevo_tornado.jpg', 'Tip: FDM, Volumen: 300x300x400 mm, Brzina: 150mm/s.', '2024-11-16'),
	(799, 'USB-C to USB-A kabel', 'Kabel za prijenos podataka i punjenje s USB-C na USB-A konektorom.', 100.00, 27, 50, 'usb_c_to_usb_a.jpg', 'Dužina: 1m, Brzina prijenosa: 5Gbps, Podrška za brzo punjenje.', '2024-11-16'),
	(800, 'HDMI kabel', 'Standardni HDMI kabel za prijenos video i audio signala.', 150.00, 27, 40, 'hdmi_kabel.jpg', 'Dužina: 2m, Verzija: 2.0, Podrška za 4K.', '2024-11-16'),
	(801, 'Ethernet kabel (Cat 6)', 'Kabel za brzi internet s brzinom do 10 Gbps.', 120.00, 27, 30, 'ethernet_cat6.jpg', 'Dužina: 3m, Kategorija: Cat 6, Brzina: do 10 Gbps.', '2024-11-16'),
	(802, 'VGA to HDMI adapter', 'Adapter za pretvorbu VGA signala u HDMI.', 250.00, 27, 25, 'vga_to_hdmi_adapter.jpg', 'Podrška za 1080p, Kompatibilno s računalima i TV uređajima.', '2024-11-16'),
	(803, 'USB-C to Lightning kabel', 'Kabel za brzo punjenje Apple uređaja s USB-C na Lightning konektorom.', 180.00, 27, 60, 'usb_c_to_lightning.jpg', 'Dužina: 1m, Brzina prijenosa: 20Gbps, Kompatibilno s iPhone uređajima.', '2024-11-16'),
	(804, 'DisplayPort to HDMI kabel', 'Kabel za prijenos slike i zvuka s DisplayPort na HDMI.', 200.00, 27, 50, 'displayport_to_hdmi.jpg', 'Dužina: 2m, Verzija: 1.2, Podrška za 4K.', '2024-11-16'),
	(805, 'USB 3.0 hub', 'USB hub za proširenje USB portova s 4 porta.', 350.00, 27, 45, 'usb_3_0_hub.jpg', 'Portovi: 4x USB 3.0, Brzina prijenosa: do 5Gbps.', '2024-11-16'),
	(806, 'Mini DisplayPort to HDMI', 'Adapter za pretvorbu Mini DisplayPort signala u HDMI.', 180.00, 27, 30, 'mini_displayport_to_hdmi.jpg', 'Podrška za 1080p, Kompatibilno s računalima i projektorima.', '2024-11-16'),
	(807, 'MHL to HDMI kabel', 'Kabel za povezivanje mobilnih uređaja s HDMI televizorom.', 200.00, 27, 20, 'mhl_to_hdmi.jpg', 'Dužina: 1.5m, Kompatibilno s većinom Android uređaja.', '2024-11-16'),
	(808, '3.5mm audio kabel', 'Kabel za prijenos audio signala s 3.5mm jack konektorom.', 80.00, 27, 60, 'audio_3_5mm_kabel.jpg', 'Dužina: 1.2m, Materijal: PVC, Podrška za stereo zvuk.', '2024-11-16'),
	(809, 'USB to Ethernet adapter', 'Adapter za povezivanje računala s mrežom putem Ethernet kabela.', 250.00, 27, 40, 'usb_to_ethernet_adapter.jpg', 'Brzina: 1000Mbps, Kompatibilno s Windows i MacOS.', '2024-11-16'),
	(810, 'USB-C to HDMI adapter', 'Adapter za povezivanje uređaja s USB-C portom na HDMI ekran.', 200.00, 27, 50, 'usb_c_to_hdmi_adapter.jpg', 'Podrška za 4K, Kompatibilno s prijenosnim računalima i telefonima.', '2024-11-16'),    
	(811, 'USB 3.0 to Gigabit Ethernet adapter', 'Adapter za povezivanje uređaja s Gigabit Ethernet mrežom.', 300.00, 27, 30, 'usb_3_0_to_ethernet_adapter.jpg', 'Brzina prijenosa: do 1000Mbps, Kompatibilno s Windows, Mac i Linux.', '2024-11-16'),
	(812, '3.5mm to RCA audio kabel', 'Audio kabel za povezivanje uređaja s 3.5mm izlazom i RCA ulazima.', 90.00, 27, 40, 'audio_3_5mm_to_rca.jpg', 'Dužina: 2m, Materijal: PVC, Stereo prijenos zvuka.', '2024-11-16'),
	(813, 'USB to USB-C kabel', 'Kabel za prijenos podataka i punjenje s USB na USB-C konektorom.', 120.00, 27, 50, 'usb_to_usb_c_kabel.jpg', 'Dužina: 1m, Brzina prijenosa: 5Gbps, Kompatibilno s novim uređajima.', '2024-11-16'),
	(814, 'Lightning to 3.5mm adapter', 'Adapter za povezivanje slušalica s 3.5mm jackom na Apple uređaje s Lightning portom.', 100.00, 27, 55, 'lightning_to_3_5mm_adapter.jpg', 'Podrška za stereo zvuk, Kompatibilno s iPhone i iPad uređajima.', '2024-11-16'),
	(815, 'USB-C to VGA adapter', 'Adapter za povezivanje uređaja s USB-C portom na VGA ekran.', 220.00, 27, 25, 'usb_c_to_vga_adapter.jpg', 'Podrška za 1080p, Kompatibilno s projektorima i starijim računalima.', '2024-11-16'),
	(816, 'Powerline Ethernet adapter', 'Adapter za povezivanje preko postojeće električne mreže za brzi internet.', 450.00, 27, 15, 'powerline_ethernet_adapter.jpg', 'Brzina prijenosa: do 1000Mbps, Podrška za mreže do 300m.', '2024-11-16'),
	(817, 'USB-C to microUSB kabel', 'Kabel za prijenos podataka i punjenje s USB-C na microUSB konektorom.', 100.00, 27, 60, 'usb_c_to_microusb.jpg', 'Dužina: 1m, Brzina prijenosa: 5Gbps, Kompatibilno s Android uređajima.', '2024-11-16'),
	(818, 'DisplayPort to DisplayPort kabel', 'Kabel za prijenos video signala između dva DisplayPort uređaja.', 250.00, 27, 45, 'displayport_to_displayport.jpg', 'Dužina: 1.5m, Verzija: 1.2, Podrška za 4K.', '2024-11-16'),
	(819, 'DVI to HDMI kabel', 'Kabel za prijenos video signala s DVI na HDMI.', 150.00, 27, 50, 'dvi_to_hdmi_kabel.jpg', 'Dužina: 2m, Kompatibilno s računalima i TV uređajima.', '2024-11-16'),
	(820, 'USB-C to DisplayPort kabel', 'Kabel za prijenos video signala s USB-C na DisplayPort.', 220.00, 27, 30, 'usb_c_to_displayport.jpg', 'Dužina: 2m, Podrška za 4K, Kompatibilno s većinom laptopa i računala.', '2024-11-16'),  
	(821, 'MicroSD to USB adapter', 'Adapter za prijenos podataka između MicroSD kartica i računala.', 100.00, 27, 55, 'microsd_to_usb_adapter.jpg', 'Podrška za MicroSD kartice, Kompatibilno s USB 2.0 i 3.0.', '2024-11-16'),        
	(822, 'USB to HDMI adapter', 'Adapter za povezivanje računala s HDMI ekranom putem USB porta.', 280.00, 27, 20, 'usb_to_hdmi_adapter.jpg', 'Podrška za 1080p, Kompatibilno s Windows i MacOS.', '2024-11-16'),
	(823, 'RJ45 coupler', 'Spojka za povezivanje dvaju Ethernet kablova.', 40.00, 27, 70, 'rj45_coupler.jpg', 'Podrška za Cat 5, 6 i 7 Ethernet kablove.', '2024-11-16'),
	(824, 'Mini HDMI to HDMI kabel', 'Kabel za prijenos video i audio signala s Mini HDMI na standardni HDMI.', 180.00, 27, 50, 'mini_hdmi_to_hdmi_kabel.jpg', 'Dužina: 1.5m, Podrška za 1080p, Kompatibilno s prijenosnim računalima i kamerama.', '2024-11-16'),
	(825, 'Type-C to Type-C kabel', 'Kabel za prijenos podataka i punjenje s USB-C na USB-C konektorom.', 150.00, 27, 50, 'type_c_to_type_c.jpg', 'Dužina: 1m, Brzina prijenosa: 10Gbps, Podrška za brzo punjenje.', '2024-11-16');


INSERT INTO popusti (proizvod_id, postotak_popusta, datum_pocetka, datum_zavrsetka) VALUES
	(1, 10.00, '2023-12-01', '2023-12-31'),
	(2, 15.00, '2023-12-05', '2023-12-25'),
	(3, 20.00, '2023-12-10', '2024-01-10'),
	(4, 25.00, '2023-11-20', '2023-12-20'),
	(5, 30.00, '2023-12-15', '2023-12-30'),
	(6, 35.00, '2023-11-01', '2023-11-30'),
	(7, 40.00, '2023-12-01', '2023-12-31'),
	(8, 45.00, '2024-01-01', '2024-01-15'),
	(9, 50.00, '2023-12-20', '2024-01-05'),
	(10, 5.00, '2023-11-25', '2023-12-05'),
	(1, 10.00, '2024-01-01', '2024-01-31'),
	(2, 12.50, '2024-01-15', '2024-02-15'),
	(3, 8.00, '2023-12-20', '2023-12-31'),
	(4, 18.00, '2024-02-01', '2024-02-28'),
	(5, 22.50, '2024-01-10', '2024-01-25'),
	(6, 33.00, '2024-01-15', '2024-02-15'),
	(7, 27.50, '2024-03-01', '2024-03-20'),
	(8, 19.00, '2024-02-10', '2024-02-25'),
	(9, 50.00, '2024-03-01', '2024-03-31'),
	(10, 5.00, '2023-12-01', '2023-12-15'),
	(1, 12.00, '2023-12-10', '2023-12-20'),
	(2, 20.00, '2023-12-15', '2023-12-31'),
	(3, 25.00, '2024-01-01', '2024-01-20'),
	(4, 30.00, '2024-02-01', '2024-02-28'),
	(5, 35.00, '2024-03-01', '2024-03-15'),
	(6, 40.00, '2024-03-20', '2024-03-31'),
	(7, 15.00, '2023-12-25', '2024-01-05'),
	(8, 18.00, '2024-01-15', '2024-01-30'),
	(9, 22.50, '2024-02-10', '2024-02-25'),
	(10, 10.00, '2023-12-05', '2023-12-20'),
    (11, 5.00, '2024-01-10', '2024-01-20'),
    (12, 12.00, '2024-02-01', '2024-02-15'),
    (13, 18.50, '2024-03-05', '2024-03-25'),
    (14, 22.00, '2024-01-20', '2024-02-05'),
    (15, 27.50, '2024-02-10', '2024-02-28'),
    (16, 33.00, '2024-03-15', '2024-03-31'),
    (17, 45.00, '2024-01-01', '2024-01-10'),
    (18, 50.00, '2024-02-20', '2024-03-10'),
    (19, 7.50, '2024-03-01', '2024-03-15'),
    (20, 15.00, '2024-01-25', '2024-02-10');


INSERT INTO korisnici (ime, prezime, email, lozinka, adresa, grad, telefon, tip_korisnika, datum_registracije) VALUES
	('Ivan', 'Horvat', 'ivan.horvat@email.com', 'lozinka123', 'Ilica 12, Zagreb', 'Zagreb', '0912345678', 'admin', '2023-01-01'),
	('Ana', 'Marić', 'ana.maric@email.com', 'lozinka123', 'Trg bana Jelačića 4, Zagreb', 'Zagreb', '0922345678', 'admin', '2023-02-15'),
	('Marko', 'Kovačić', 'marko.kovacic@email.com', 'lozinka123', 'Ulica grada Vukovara 10, Split', 'Split', '0913456789', 'kupac', '2024-03-10'),
	('Maja', 'Perić', 'maja.peric@email.com', 'lozinka123', 'Ante Starčevića 5, Rijeka', 'Rijeka', '0923456789', 'kupac', '2024-04-01'),
	('Luka', 'Jurić', 'luka.juric@email.com', 'lozinka123', 'Zagrebačka 15, Osijek', 'Osijek', '0914567890', 'kupac', '2024-04-10'),
	('Petra', 'Babić', 'petra.babic@email.com', 'lozinka123', 'Kralja Tomislava 2, Zadar', 'Zadar', '0924567890', 'kupac', '2024-05-05'),
	('Janko', 'Damić', 'janko.damic@email.com', 'lozinka123', 'Dubrava 10, Osijek', 'Osijek', '0915678901', 'kupac', '2024-05-15'),
	('Lucija', 'Brezina', 'lucija.brezina@email.com', 'lozinka123', 'Stara cesta 20, Varaždin', 'Varaždin', '0925678901', 'kupac', '2024-06-01'),
	('Tomislav', 'Novak', 'tomislav.novak@email.com', 'lozinka123', 'Istarska 8, Rijeka', 'Rijeka', '0916789012', 'kupac', '2024-07-20'),
	('Ivana', 'Vuković', 'ivana.vukovic@email.com', 'lozinka123', 'Šibenik 11, Šibenik', 'Šibenik', '0926789012', 'kupac', '2024-07-25'),
	('Nikola', 'Lukić', 'nikola.lukic@email.com', 'lozinka123', 'Vukovarska 30, Pula', 'Pula', '0917890123', 'kupac', '2024-08-12'),
	('Klara', 'Drljača', 'klara.drljaca@email.com', 'lozinka123', 'Riječka 13, Dubrovnik', 'Dubrovnik', '0927890123', 'kupac', '2024-08-15'),
	('Davor', 'Savić', 'davor.savic@email.com', 'lozinka123', 'Valpovo 7, Valpovo', 'Valpovo', '0918901234', 'kupac', '2024-09-05'),
	('Sanja', 'Božić', 'sanja.bozic@email.com', 'lozinka123', 'Banjole 14, Pula', 'Pula', '0928901234', 'kupac', '2024-09-10'),
	('Filip', 'Matijaš', 'filip.matijas@email.com', 'lozinka123', 'Nikole Tesle 4, Zadar', 'Zadar', '0919012345', 'kupac', '2024-10-01'),
	('Marija', 'Kralj', 'marija.kralj@email.com', 'lozinka123', 'Krk 3, Krk', 'Krk', '0929012345', 'kupac', '2024-10-10'),
	('Ivica', 'Živanović', 'ivica.zivanovic@email.com', 'lozinka123', 'Dubrovačka 5, Split', 'Split', '0910123456', 'kupac', '2024-11-01'),
	('Diana', 'Rašić', 'diana.rasic@email.com', 'lozinka123', 'Vukovar 8, Vukovar', 'Vukovar', '0920123456', 'kupac', '2024-11-05'),
	('Stjepan', 'Galić', 'stjepan.galic@email.com', 'lozinka123', 'Zeleni trg 9, Osijek', 'Osijek', '0911234567', 'kupac', '2024-11-15'),
	('Jelena', 'Knežević', 'jelena.knezevic@email.com', 'lozinka123', 'Cres 6, Cres', 'Cres', '0921234567', 'kupac', '2024-12-01'),
	('Petar', 'Šimunić', 'petar.simunic@email.com', 'lozinka123', 'Rijeka 4, Rijeka', 'Rijeka', '0912345678', 'kupac', '2024-12-10'),
	('Kristina', 'Puljić', 'kristina.puljic@email.com', 'lozinka123', 'Istarska 12, Trogir', 'Trogir', '0922345678', 'kupac', '2024-12-20'),
	('Ante', 'Zorić', 'ante.zoric@email.com', 'lozinka123', 'Čakovec 16, Čakovec', 'Čakovec', '0913456789', 'kupac', '2024-12-25'),
	('Marin', 'Bilić', 'marin.bilic@email.com', 'lozinka123', 'Splitska 21, Split', 'Split', '0923456789', 'kupac', '2025-01-01'),
	('Jasna', 'Brkić', 'jasna.brkic@email.com', 'lozinka123', 'Dubrovačka 10, Sisak', 'Sisak', '0914567890', 'kupac', '2025-01-05'),
	('Viktor', 'Tomić', 'viktor.tomic@email.com', 'lozinka123', 'Ulica 10, Vukovar', 'Vukovar', '0924567890', 'kupac', '2025-01-15'),
	('Tatjana', 'Ivančić', 'tatjana.ivancic@email.com', 'lozinka123', 'Medulićeva 7, Rijeka', 'Rijeka', '0915678901', 'kupac', '2025-02-01'),
	('Slaven', 'Matić', 'slaven.matic@email.com', 'lozinka123', 'Petrova 4, Zagreb', 'Zagreb', '0925678901', 'kupac', '2025-02-10'),
	('Nina', 'Marković', 'nina.markovic@email.com', 'lozinka123', 'Preko 20, Preko', 'Preko', '0916789012', 'kupac', '2025-02-20'),
	('Marija', 'Kolarić', 'marija.kolaric@email.com', 'lozinka123', 'Ravne njive 5, Rijeka', 'Rijeka', '0926789012', 'kupac', '2025-03-01'),
	('Davor', 'Tomić', 'davor.tomic@email.com', 'lozinka123', 'Starčević 12, Varaždin', 'Varaždin', '0917890123', 'kupac', '2025-03-10'),
	('Zlatko', 'Čolović', 'zlatko.colovic@email.com', 'lozinka123', 'Varaždinska 1, Varaždin', 'Varaždin', '0927890123', 'kupac', '2025-03-20');

INSERT INTO recenzije_proizvoda (proizvod_id, korisnik_id, ocjena, komentar) VALUES
	(1, 1, 5, 'Odličan proizvod, preporučujem!'),
	(2, 2, 4, 'Vrlo dobar proizvod, ali ima sitnih nedostataka.'),
	(3, 3, 3, 'Solidan proizvod, ništa posebno.'),
	(4, 4, 2, 'Proizvod nije ispunio moja očekivanja.'),
	(5, 5, 1, 'Vrlo loše iskustvo, ne preporučujem.'),
	(6, 6, 4, 'Dobro radi, ali ima prostora za poboljšanja.'),
	(7, 7, 5, 'Fantastičan proizvod, vrijedi svake kune!'),
	(8, 8, 3, 'Prosječan proizvod, nije loš.'),
	(9, 9, 2, 'Ne bih ponovno kupio.'),
	(10, 10, 4, 'Dobar proizvod, zadovoljan sam.'),
	(11, 11, 5, 'Odlična kvaliteta, vrijedi kupiti.'),
	(12, 12, 4, 'Vrlo dobar, ali malo preskup.'),
	(13, 13, 3, 'Radi kako je opisano, ali ništa posebno.'),
	(14, 14, 2, 'Loša kvaliteta, razočaran sam.'),
	(15, 15, 1, 'Izuzetno loš proizvod, izbjegavati.'),
	(16, 16, 5, 'Vrlo zadovoljan kupnjom, sve pohvale!'),
	(17, 17, 4, 'Dobro izrađen, vrijedi cijene.'),
	(18, 18, 3, 'Osrednje iskustvo, mogao bi biti bolji.'),
	(19, 19, 2, 'Nije vrijedan novca.'),
	(20, 20, 5, 'Izvanredan proizvod, preporučujem svima!'),
	(21, 21, 5, 'Izvanredan proizvod!'),
	(22, 22, 5, 'Preporučujem svima!'),
	(23, 23, 4, 'Solidno.'),
	(24, 24, 4, 'Ništa posebno.'),
	(25, 25, 5, 'Fantastičan proizvod, vrijedi!'),
	(26, 26, 4, 'Moglo bi i bolje.'),
	(27, 27, 4, 'Dobar proizvod.'),
	(28, 28, 4, 'Ipak mislim da može mrvicu bolje.'),
	(29, 29, 3, 'Nije loše ajmo reć.'),
	(30, 30, 4, 'Sve ok osim što smatram da je malo preskup ovaj proizvod');


INSERT INTO nacini_isporuke (naziv, opis, cijena, trajanje) VALUES
	('Dostava na adresu', 'Dostava proizvoda na adresu kupca putem kurirske službe.', 50.00, 3),
	('Osobno preuzimanje', 'Kupac može osobno preuzeti proizvode u trgovini.', 0.00, 0),
	('Brza dostava', 'Dostava proizvoda putem kurirske službe u ekspresnom roku.', 80.00, 2),
	('Dostava na paketomat', 'Dostava na odabrani paketomat, kupac preuzima paket u paketu s PIN kodom.', 40.00, 5);
    
INSERT INTO kosarica (id, korisnik_id, proizvod_id, kolicina)
VALUES
 (1, 8, 101, 3),
 (2, 18, 102, 5),
 (3, 29, 103, 2),
 (4, 3, 104, 7),
 (5, 28, 105, 4),
 (6, 30, 106, 1),
 (7, 14, 107, 6),
 (8, 16, 108, 8),
 (9, 2, 109, 2),
 (10, 3, 110, 3),
 (11, 9, 111, 4),
 (12, 20, 112, 7),
 (13, 11, 113, 1),
 (14, 23, 114, 2),
 (15, 25, 115, 5),
 (16, 9, 116, 9),
 (17, 1, 117, 6),
 (18, 15, 118, 3),
 (19, 9, 119, 4),
 (20, 13, 120, 7),
 (21, 7, 121, 2),
 (22, 10, 122, 3),
 (23, 20, 123, 5),
 (24, 13, 124, 8),
 (25, 12, 125, 1),
 (26, 8, 126, 9),
 (27, 27, 127, 6),
 (28, 22, 128, 4),
 (29, 23, 129, 2),
 (30, 9, 130, 7);

INSERT INTO kuponi (kod, postotak_popusta, datum_pocetka, datum_zavrsetka, max_iskoristenja) VALUES
('WELCOME10', 10.00, '2025-01-01', '2025-06-30', 100),
('SPRING15', 15.00, '2025-03-01', '2025-05-31', 50),
('SUMMER20', 20.00, '2025-06-01', '2025-08-31', 75),
('AUTUMN25', 25.00, '2025-09-01', '2025-11-30', 50),
('WINTER30', 30.00, '2025-12-01', '2026-02-28', 30),
('FREESHIP', 0.00, '2025-01-01', '2025-12-31', 200),
('BLACKFRIDAY50', 50.00, '2025-11-20', '2025-11-30', 100),
('CYBERMONDAY40', 40.00, '2025-11-28', '2025-12-05', 75),
('NEWYEAR25', 25.00, '2025-12-25', '2026-01-05', 60),
('HOLIDAY15', 15.00, '2025-12-01', '2025-12-31', 150),
('VIPCUSTOMER', 20.00, '2025-01-01', '2025-12-31', 50),
('WELCOME2025', 10.00, '2025-01-01', '2025-03-31', 300),
('DISCOUNT5', 5.00, '2025-01-01', '2025-12-31', 500),
('EXCLUSIVE35', 35.00, '2025-02-01', '2025-04-30', 20),
('STUDENT10', 10.00, '2025-09-01', '2026-06-30', 100),
('TEACHER20', 20.00, '2025-09-01', '2026-06-30', 50),
('REFERFRIEND', 15.00, '2025-01-01', '2025-12-31', 100),
('LOYALTY50', 50.00, '2025-01-01', '2025-12-31', 20),
('WEEKEND20', 20.00, '2025-01-01', '2025-12-31', 100),
('FIRSTPURCHASE', 30.00, '2025-01-01', '2025-12-31', 50),
('SPECIAL30', 30.00, '2025-03-01', '2025-03-15', 30),
('WINTERCLEAR', 25.00, '2025-01-01', '2025-01-31', 80),
('SUMMERSALE', 20.00, '2025-06-15', '2025-07-15', 50),
('BACKTOSCHOOL', 15.00, '2025-08-01', '2025-09-15', 60),
('HALLOWEEN30', 30.00, '2025-10-20', '2025-10-31', 40),
('CHRISTMAS40', 40.00, '2025-12-01', '2025-12-25', 50),
('CLEARANCE50', 50.00, '2025-01-01', '2025-01-15', 30),
('BULKBUY10', 10.00, '2025-01-01', '2025-12-31', 100),
('FAMILY15', 15.00, '2025-01-01', '2025-12-31', 50),
('BIRTHDAY25', 25.00, '2025-01-01', '2025-12-31', 20);

    
INSERT INTO narudzbe (id, korisnik_id, datum_narudzbe, status_narudzbe, ukupna_cijena, nacin_isporuke_id, kupon_id) VALUES
	(1, 1, '2024-01-01', 'dostavljeno', 6999.99, 2, NULL),
	(2, 2, '2024-01-02', 'dostavljeno', 10999.99, 2, NULL),
	(3, 3, '2024-01-03', 'dostavljeno', 12999.99, 2, NULL),
	(4, 4, '2024-01-04', 'dostavljeno', 14999.99, 2, NULL),
	(5, 5, '2024-01-05', 'dostavljeno', 5999.99,2, NULL),
	(6, 16, '2024-01-06', 'dostavljeno', 10999.99, 2, NULL),
	(7, 27, '2024-01-07', 'dostavljeno', 19999.99, 2, NULL),
	(8, 25, '2024-01-08', 'dostavljeno', 13999.99, 2, NULL),
	(9, 24, '2024-01-09', 'dostavljeno', 4999.99, 2, NULL),
	(10, 23, '2024-01-10', 'dostavljeno', 4499.99, 2, NULL),
	(11, 21, '2024-01-11', 'dostavljeno', 4999.99, 2, NULL),
	(12, 11, '2024-01-12', 'dostavljeno', 5499.99, 2, NULL),
	(13, 15, '2024-01-13', 'dostavljeno', 15999.99, 2, NULL),
	(14, 6, '2024-01-14', 'dostavljeno', 13999.99, 2, NULL),
	(15, 7, '2024-01-15', 'dostavljeno', 17999.99, 2, NULL),
	(16, 8, '2024-01-16', 'dostavljeno', 10999.99, 2, NULL),
	(17, 9, '2024-01-17', 'dostavljeno', 9999.99, 2, NULL),
	(18, 10, '2024-01-18', 'dostavljeno', 8499.99, 2, NULL),
	(19, 11, '2024-01-19', 'dostavljeno', 13999.99, 2, NULL),
	(20, 12, '2024-01-20', 'dostavljeno', 6999.99, 2, NULL),
	(21, 13, '2024-01-21', 'dostavljeno', 13999.99, 2, NULL),
	(22, 14, '2024-01-22', 'dostavljeno', 10999.99, 2, NULL),
	(23, 15, '2024-01-23', 'dostavljeno', 13999.99, 2, NULL),
	(24, 17, '2024-01-24', 'dostavljeno', 9999.99, 2, NULL),
	(25, 22, '2024-01-25', 'dostavljeno', 10999.99, 2, NULL),
	(26, 21, '2024-01-26', 'dostavljeno', 9999.99, 2, NULL),
	(27, 12, '2024-01-27', 'dostavljeno', 15999.99, 2, NULL),
	(28, 18, '2024-01-28', 'dostavljeno', 18999.99, 2, NULL),
	(29, 19, '2024-01-29', 'dostavljeno', 10999.99, 2, NULL),
	(30, 20, '2024-01-30', 'dostavljeno', 12999.99, 2, NULL);
    

INSERT INTO stavke_narudzbe (narudzba_id, proizvod_id, kolicina) VALUES
	(1, 1, 1),
	(2, 2, 1),
	(3, 3, 1),
	(4, 4, 1),
	(5, 5, 1),
	(6, 6, 1),
	(7, 7, 1),
	(8, 8, 1),
	(9, 9, 1),
	(10, 10, 1),
	(11, 11, 1),
	(12, 12, 1),
	(13, 13, 1),
	(14, 14, 1),
	(15, 15, 1),
	(16, 16, 1),
	(17, 17, 1),
	(18, 18, 1),
	(19, 19, 1),
	(20, 20, 1),
	(21, 21, 1),
	(22, 22, 1),
	(23, 23, 1),
	(24, 24, 1),
	(25, 25, 1),
	(26, 26, 1),
	(27, 27, 1),
	(28, 28, 1),
	(29, 29, 1),
	(30, 30, 1);




INSERT INTO placanja (narudzba_id, nacin_placanja, iznos, datum_placanja) VALUES
	(1, 'kartica', 6999.99, '2024-01-01'),
	(2, 'pouzeće', 10999.99, '2024-01-02'),
	(3, 'kartica', 12999.99, '2024-01-03'),
	(4, 'kartica', 14999.99, '2024-01-04'),
	(5, 'pouzeće', 5999.99, '2024-01-05'),
	(6, 'kartica', 10999.99, '2024-01-06'),
	(7, 'pouzeće', 19999.99, '2024-01-07'),
	(8, 'kartica', 13999.99, '2024-01-08'),
	(9, 'kartica', 4999.99, '2024-01-09'),
	(10, 'pouzeće', 4499.99, '2024-01-10'),
	(11, 'kartica', 4999.99, '2024-01-11'),
	(12, 'pouzeće', 5499.99, '2024-01-12'),
	(13, 'kartica', 15999.99, '2024-01-13'),
	(14, 'pouzeće', 13999.99, '2024-01-14'),
	(15, 'kartica', 17999.99, '2024-01-15'),
	(16, 'pouzeće', 10999.99, '2024-01-16'),
	(17, 'kartica', 9999.99, '2024-01-17'),
	(18, 'kartica', 8499.99, '2024-01-18'),
	(19, 'pouzeće', 13999.99, '2024-01-19'),
	(20, 'kartica', 6999.99, '2024-01-20'),
	(21, 'kartica', 13999.99, '2024-01-21'),
	(22, 'pouzeće', 10999.99, '2024-01-22'),
	(23, 'kartica', 13999.99, '2024-01-23'),
	(24, 'pouzeće', 9999.99, '2024-01-24'),
	(25, 'kartica', 10999.99, '2024-01-25'),
	(26, 'kartica', 9999.99, '2024-01-26'),
	(27, 'pouzeće', 15999.99, '2024-01-27'),
	(28, 'kartica', 18999.99, '2024-01-28'),
	(29, 'kartica', 10999.99, '2024-01-29'),
	(30, 'pouzeće', 12999.99, '2024-01-30');


INSERT INTO racuni (korisnik_id, narudzba_id, iznos, datum_izdavanja) VALUES
	(1, 1, 6999.99, '2024-01-01'),
	(2, 2, 10999.99, '2024-01-02'),
	(3, 3, 12999.99, '2024-01-03'),
	(4, 4, 14999.99, '2024-01-04'),
	(5, 5, 5999.99, '2024-01-05'),
	(6, 6, 10999.99, '2024-01-06'),
	(7, 7, 19999.99, '2024-01-07'),
	(8, 8, 13999.99, '2024-01-08'),
	(9, 9, 4999.99, '2024-01-09'),
	(10, 10, 4499.99, '2024-01-10'),
	(11, 11, 4999.99, '2024-01-11'),
	(12, 12, 5499.99, '2024-01-12'),
	(13, 13, 15999.99, '2024-01-13'),
	(14, 14, 13999.99, '2024-01-14'),
	(15, 15, 17999.99, '2024-01-15'),
	(16, 16, 10999.99, '2024-01-16'),
	(17, 17, 9999.99, '2024-01-17'),
	(18, 18, 8499.99, '2024-01-18'),
	(19, 19, 13999.99, '2024-01-19'),
	(20, 20, 6999.99, '2024-01-20'),
	(21, 21, 13999.99, '2024-01-21'),
	(22, 22, 10999.99, '2024-01-22'),
	(23, 23, 13999.99, '2024-01-23'),
	(24, 24, 9999.99, '2024-01-24'),
	(25, 25, 10999.99, '2024-01-25'),
	(26, 26, 9999.99, '2024-01-26'),
	(27, 27, 15999.99, '2024-01-27'),
	(28, 28, 18999.99, '2024-01-28'),
	(29, 29, 10999.99, '2024-01-29'),
	(30, 30, 12999.99, '2024-01-30');




ALTER TABLE wishlist ADD grupa VARCHAR(255) DEFAULT 'Bez grupe'; -- (Leo)
INSERT INTO wishlist (korisnik_id, proizvod_id, grupa)
VALUES
    (1, 1, 'Gaming oprema'),
    (1, 2, 'Za posao'),
    (2, 3, 'Gaming oprema'),
    (3, 4, 'Kućna elektronika'),
    (2, 5, 'Hobi'),
    (4, 6, 'Za posao'),
    (5, 7, 'Gaming oprema'),
    (6, 8, 'Kućna elektronika'),
    (7, 9, 'Hobi'),
    (8, 10, 'Gaming oprema'),
    (9, 11, 'Za posao'),
    (10, 12, 'Kućna elektronika'),
    (11, 13, 'Hobi'),
    (12, 14, 'Gaming oprema'),
    (13, 15, 'Za posao'),
    (14, 16, 'Kućna elektronika'),
    (15, 17, 'Hobi'),
    (16, 18, 'Gaming oprema'),
    (17, 19, 'Za posao'),
    (18, 20, 'Kućna elektronika'),
    (19, 21, 'Hobi'),
    (20, 22, 'Gaming oprema'),
    (21, 23, 'Za posao'),
    (22, 24, 'Kućna elektronika'),
    (23, 25, 'Hobi'),
    (24, 26, 'Gaming oprema'),
    (25, 27, 'Za posao'),
    (26, 28, 'Kućna elektronika'),
    (27, 29, 'Hobi'),
    (28, 30, 'Gaming oprema');


INSERT INTO preporuceni_proizvodi (korisnik_id, proizvod_id, razlog_preporuke)
VALUES 
    (1, 1, 'Proizvod je popularan među korisnicima i dobro je ocijenjen.'),
    (1, 2, 'Sviđa mi se dizajn ovog proizvoda, mislim da bi ti odgovarao.'),
    (2, 3, 'Proizvod ima dobru funkcionalnost i odličnu cijenu.'),
    (3, 4, 'Preporučujem ga jer je sličan proizvodu koji sam već kupio.'),
    (2, 5, 'Ovaj proizvod je vrlo korisna stvar za svakodnevnu upotrebu.'),
    (4, 6, 'Dobar je za kolekciju, mislim da bi ti bio zanimljiv.'),
    (5, 1, 'Kvaliteta ovog proizvoda je izvrsna, vrlo je popularan.'),
    (6, 2, 'Ovaj proizvod je visoko ocijenjen i dobro se prodaje.'),
    (7, 3, 'Sviđa mi se kako ovaj proizvod radi, mislim da će ti koristiti.'),
    (8, 4, 'Preporučujem ga jer ima dobre karakteristike za cijenu.'),
    (9, 5, 'Moj prijatelj ga koristi i veoma je zadovoljan.'),
    (10, 6, 'Ovaj proizvod je odličan za tvoje potrebe, mogao bi ga isprobati.'),
    (11, 7, 'Već sam ga isprobao i bio sam impresioniran, trebao bi ga imati.'),
    (12, 8, 'Poznajem ljude koji koriste ovaj proizvod, kažu da je odličan.'),
    (13, 9, 'Ovaj proizvod se često koristi za tvoju vrstu posla, mislim da bi bio koristan.'),
    (14, 10, 'Veoma je popularan i ima puno pozitivnih recenzija.'),
    (15, 11, 'Isprobao sam ga i siguran sam da bi ti odgovarao.'),
    (16, 12, 'Sviđa mi se njegova funkcionalnost, mislim da bi ti bio koristan.'),
    (17, 13, 'Ovaj proizvod je idealan za tvoje potrebe, preporučujem ga.'),
    (18, 14, 'Vrlo kvalitetan proizvod, mislim da bi ti mogao odgovarati.'),
    (19, 15, 'Prijatelj ga koristi i preporučuje ga svima.'),
    (20, 16, 'Ovaj proizvod je zaista povoljan za cijenu, mislim da bi ga volio.'),
    (21, 17, 'Dobar je izbor za tvoje tehničke zahtjeve, sigurno bi ti odgovarao.'),
    (22, 18, 'Veoma kvalitetan proizvod, teško je naći bolji za ovu cijenu.'),
    (23, 19, 'Poznajem nekoliko korisnika koji ga koriste i svi su zadovoljni.'),
    (24, 20, 'Sviđa mi se funkcionalnost, preporučujem ga za tvoje svakodnevne potrebe.'),
    (25, 21, 'Proizvod je vrlo izdržljiv i ima pozitivne recenzije, preporučujem.'),
    (26, 22, 'Čuo sam mnogo dobrih stvari o njemu, mislim da bi ti bio koristan.'),
    (27, 23, 'Veoma je popularan među korisnicima tvoje kategorije, mislim da ti odgovara.'),
    (28, 24, 'Ovaj proizvod je odličan za korištenje u tvojoj industriji.'),
    (29, 25, 'Kvaliteta je na vrhu, mislim da bi ti bio vrlo koristan.'),
    (30, 26, 'Veoma je svestran i mislim da bi ti mogao koristiti za više svrha.');






-- Pogled: za korisnički profil (Leo)
CREATE VIEW profil_korisnika AS
SELECT 
    id AS korisnik_id,
    ime,
    prezime,
    email,
    adresa,
    grad,
    telefon,
    datum_registracije,
	tip_korisnika
FROM korisnici;

-- Pogled: Popularni proizvodi (najviše puta dodati u wishlist) (Leo)
CREATE VIEW popularni_proizvodi AS
SELECT 
    p.id AS proizvod_id,
    p.naziv,
    COUNT(w.proizvod_id) AS broj_dodavanja
FROM proizvodi p
LEFT JOIN wishlist w ON p.id = w.proizvod_id
GROUP BY p.id, p.naziv
ORDER BY broj_dodavanja DESC;

-- Pogled: Preporuke drugih (Leo)
CREATE VIEW preporuke_drugih AS
SELECT 
    k.id AS korisnik_id,
    k.ime,
    k.prezime,
    p.naziv AS proizvod_naziv,
    pp.razlog_preporuke
FROM preporuceni_proizvodi pp
JOIN korisnici k ON pp.korisnik_id = k.id
JOIN proizvodi p ON pp.proizvod_id = p.id;


--  Pogled: Narudžbe Korisnika (Leo)
CREATE VIEW narudzbe_korisnika AS
SELECT 
    n.id AS narudzba_id,
    n.datum_narudzbe,
    n.status_narudzbe AS status,
    s.proizvod_id,
    p.naziv AS proizvod_naziv,
    s.kolicina,
    s.kolicina * p.cijena AS ukupna_cijena_proizvoda,
    n.korisnik_id
FROM narudzbe n
JOIN stavke_narudzbe s ON n.id = s.narudzba_id
JOIN proizvodi p ON s.proizvod_id = p.id;

-- Procedura: Dodavanje korisnika (Leo)
DELIMITER //
CREATE PROCEDURE dodaj_korisnika(
    IN p_ime VARCHAR(255),
    IN p_prezime VARCHAR(255),
    IN p_email VARCHAR(255),
    IN p_lozinka VARCHAR(255),
    IN p_adresa TEXT,
    IN p_grad VARCHAR(255),
    IN p_telefon VARCHAR(20)
)
BEGIN
    IF EXISTS (SELECT 1 FROM korisnici WHERE email = p_email) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Korisnik sa ovim email-om već postoji!';
    ELSE
        INSERT INTO korisnici (ime, prezime, email, lozinka, adresa, grad, telefon, tip_korisnika, datum_registracije)
        VALUES (p_ime, p_prezime, p_email, p_lozinka, p_adresa, p_grad, p_telefon, 'kupac', CURDATE());
    END IF;
END//
DELIMITER ;

-- Procedura: Prikaz personaliziranih preporuka (Leo)
DELIMITER //

CREATE PROCEDURE prikazi_preporuke(korisnik_id INT, page INT, per_page INT)
BEGIN
    DECLARE offset_value INT;

    -- Izračunavanje offset-a
    SET offset_value = (page - 1) * per_page;

    SELECT 
        p.id AS proizvod_id,
        p.naziv,
        p.opis,
        p.cijena
    FROM proizvodi p
    WHERE p.kategorija_id IN (
        -- Preporučujemo proizvode iz kategorija koje je korisnik dodao u wishlist ili kupio
        SELECT DISTINCT p2.kategorija_id
        FROM proizvodi p2
        JOIN wishlist w ON p2.id = w.proizvod_id
        WHERE w.korisnik_id = korisnik_id
        UNION
        SELECT DISTINCT p3.kategorija_id
        FROM proizvodi p3
        JOIN stavke_narudzbe s ON p3.id = s.proizvod_id
        JOIN narudzbe n ON s.narudzba_id = n.id
        WHERE n.korisnik_id = korisnik_id
    )
    AND p.id NOT IN (
        -- Iznimamo proizvode koje je korisnik već dodao u wishlist
        SELECT proizvod_id
        FROM wishlist
        WHERE korisnik_id = korisnik_id
    )
    ORDER BY p.cijena DESC
    LIMIT per_page OFFSET offset_value;  -- Koristimo izračunati offset

END//

DELIMITER ;

-- Procedura: Dodaj u wishlist (Leo)
DELIMITER //

CREATE PROCEDURE dodaj_u_wishlist(korisnik_id INT, proizvod_id INT, grupa VARCHAR(255))
BEGIN
    INSERT INTO wishlist (korisnik_id, proizvod_id, grupa)
    VALUES (korisnik_id, proizvod_id, grupa);
END//

DELIMITER ;

-- Procedura: Ukloni u wishlist (Leo)
DELIMITER //

CREATE PROCEDURE ukloni_proizvod_iz_wishliste(p_korisnik_id INT, p_proizvod_id INT)
BEGIN
    DELETE FROM wishlist WHERE korisnik_id = p_korisnik_id AND proizvod_id = p_proizvod_id;
END//

DELIMITER ;


-- Procedura: Brisanje korisnika (Leo)
DELIMITER //

CREATE PROCEDURE obrisi_korisnika(
    IN p_korisnik_id INT
)
BEGIN
    DECLARE korisnik_ima_aktivne_narudzbe BOOLEAN;

    -- Provjera da li korisnik ima aktivne narudžbe koje nisu 'dostavljeno'
    SELECT EXISTS (SELECT 1 FROM narudzbe WHERE korisnik_id = p_korisnik_id AND status_narudzbe != 'dostavljeno')
    INTO korisnik_ima_aktivne_narudzbe;

    IF korisnik_ima_aktivne_narudzbe THEN
        SIGNAL SQLSTATE '45001'
        SET MESSAGE_TEXT = 'Korisnik ima aktivne narudžbe i ne može se obrisati!';
    ELSE
        -- Brisanje povezanih podataka u preporuceni_proizvodi
        DELETE FROM preporuceni_proizvodi WHERE korisnik_id = p_korisnik_id;

        -- Brisanje povezanih recenzija
        DELETE FROM recenzije_proizvoda WHERE korisnik_id = p_korisnik_id;

        -- Brisanje povezanih računa 
        DELETE FROM racuni WHERE korisnik_id = p_korisnik_id;

        -- Brisanje povezanih podataka
        DELETE FROM placanja WHERE narudzba_id IN (SELECT id FROM narudzbe WHERE korisnik_id = p_korisnik_id);
        DELETE FROM stavke_narudzbe WHERE narudzba_id IN (SELECT id FROM narudzbe WHERE korisnik_id = p_korisnik_id);
        DELETE FROM narudzbe WHERE korisnik_id = p_korisnik_id;
        DELETE FROM wishlist WHERE korisnik_id = p_korisnik_id;

        -- Na kraju, brisanje korisnika
        DELETE FROM korisnici WHERE id = p_korisnik_id;
    END IF;
END //

DELIMITER ;



-- Procedura: Ažuriranje korsinika(Leo)
DELIMITER //
CREATE PROCEDURE azuriraj_korisnika(
    IN p_korisnik_id INT,
    IN p_ime VARCHAR(255),
    IN p_prezime VARCHAR(255),
    IN p_email VARCHAR(255),
    IN p_adresa TEXT,
    IN p_grad VARCHAR(255),
    IN p_telefon VARCHAR(20)
)
BEGIN
    UPDATE korisnici
    SET 
        ime = p_ime,
        prezime = p_prezime,
        email = p_email,
        adresa = p_adresa,
        grad = p_grad,
        telefon = p_telefon
    WHERE id = p_korisnik_id;
END//
DELIMITER ;

DELIMITER //

-- Procedura: Ažuriranje tipa korsinika(Leo)	
CREATE PROCEDURE azuriraj_tip_korisnika(IN p_korisnik_id INT, IN p_tip_korisnika ENUM('kupac', 'admin'))
BEGIN
    UPDATE korisnici
    SET tip_korisnika = p_tip_korisnika
    WHERE id = p_korisnik_id;
END//

DELIMITER ;

-- Okidač: Automatsko postavljanje datuma registracije korisnika (Leo)
DELIMITER //
CREATE TRIGGER postavi_datum_registracije
BEFORE INSERT ON korisnici
FOR EACH ROW
BEGIN
    IF NEW.datum_registracije IS NULL THEN
        SET NEW.datum_registracije = CURDATE();
    END IF;
END//
DELIMITER ;


-- Okidač: spreči duplikate wishlist (Leo)
DELIMITER //
CREATE TRIGGER spreči_duplikate_wishlist
BEFORE INSERT ON wishlist
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1
        FROM wishlist
        WHERE korisnik_id = NEW.korisnik_id AND proizvod_id = NEW.proizvod_id
    ) THEN
        SIGNAL SQLSTATE '45002'
        SET MESSAGE_TEXT = 'Proizvod je već u wishlist-u ovog korisnika!';
    END IF;
END//
DELIMITER ;

-- Funkcija: Formatiranje datuma (Leo)
DELIMITER //
CREATE FUNCTION formatiraj_datum(input_date DATE)
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
    RETURN DATE_FORMAT(input_date, '%d.%m.%Y');
END//
DELIMITER ;

-- Upit: Provjera popularnosti proizvoda (koji proizvodi su najčešće dodati u wishlist) (Leo)
SELECT 
    p.id AS proizvod_id,
    p.naziv AS proizvod_naziv,
    COUNT(w.proizvod_id) AS broj_dodavanja
FROM proizvodi p
LEFT JOIN wishlist w ON p.id = w.proizvod_id
GROUP BY p.id, p.naziv
ORDER BY broj_dodavanja DESC
LIMIT 5; -- Dohvata prvih 5 proizvoda

-- Upit: Provjera korisnika sa najviše narudžbi (Leo)
SELECT 
    k.id AS korisnik_id,
    k.ime,
    k.prezime,
    COUNT(n.id) AS broj_narudzbi
FROM korisnici k
JOIN narudzbe n ON k.id = n.korisnik_id
GROUP BY k.id, k.ime, k.prezime
ORDER BY broj_narudzbi DESC
LIMIT 5; -- Prikazuje prvih 5 korisnika sa najviše narudžbi

-- Upit: Ukupna zarada po korisnicima na osnovu narudžbi(Leo)
SELECT 
    k.id AS korisnik_id,
    k.ime,
    k.prezime,
    SUM(n.ukupna_cijena) AS ukupna_zarada
FROM korisnici k
JOIN narudzbe n ON k.id = n.korisnik_id
GROUP BY k.id, k.ime, k.prezime
ORDER BY ukupna_zarada DESC;

SHOW TRIGGERS;
SHOW WARNINGS;
ALTER TABLE racuni
DROP FOREIGN KEY racuni_ibfk_2; 

ALTER TABLE racuni
ADD CONSTRAINT racuni_ibfk_2 FOREIGN KEY (korisnik_id) REFERENCES korisnici(id) ON DELETE CASCADE;
ALTER TABLE pracenje_isporuka
DROP FOREIGN KEY pracenje_isporuka_ibfk_1;

ALTER TABLE pracenje_isporuka
ADD CONSTRAINT pracenje_isporuka_ibfk_1 FOREIGN KEY (narudzba_id) REFERENCES narudzbe(id) ON DELETE CASCADE;


######## Loren ###########

-- Pogled: Svi proizvodi s kategorijama (Loren)

CREATE VIEW svi_proizvodi_s_kategorijama AS
SELECT 
    p.id AS proizvod_id, 
    p.naziv AS proizvod, 
    p.cijena, 
    k.naziv AS kategorija, 
    p.kolicina_na_skladistu
FROM proizvodi p
JOIN kategorije_proizvoda k ON p.kategorija_id = k.id;

/*
SELECT * FROM svi_proizvodi_s_kategorijama;
*/

-- Pogled: Proizvodi koji su trenutno na skladištu (Loren)

CREATE VIEW dostupni_proizvodi AS
SELECT 
    p.id AS proizvod_id, 
    p.naziv AS proizvod, 
    p.kolicina_na_skladistu
FROM proizvodi p
WHERE p.kolicina_na_skladistu > 0;

/*
SELECT * FROM dostupni_proizvodi;
*/

-- Pogled: Sve recenzije s podacima o proizvodima i korisnicima (Loren)

CREATE VIEW recenzije_s_proizvodima_i_korisnicima AS
SELECT 
    r.id AS recenzija_id, 
    p.naziv AS proizvod, 
    k.ime AS korisnik_ime, 
    r.ocjena, 
    r.komentar, 
    r.datum_recenzije
FROM recenzije_proizvoda r
JOIN proizvodi p ON r.proizvod_id = p.id
JOIN korisnici k ON r.korisnik_id = k.id;

/*
SELECT * FROM recenzije_s_proizvodima_i_korisnicima;
*/

-- Pogled: najpopularnijih proizvoda s najvećim brojem recenzija (Loren)

CREATE VIEW najpopularniji_proizvodi AS
SELECT 
    p.id AS proizvod_id, 
    p.naziv AS proizvod, 
    COUNT(r.id) AS broj_recenzija
FROM proizvodi p
LEFT JOIN recenzije_proizvoda r ON p.id = r.proizvod_id
GROUP BY p.id, p.naziv
ORDER BY broj_recenzija DESC;

/*
SELECT * FROM najpopularniji_proizvodi;
*/

-- Pogled: Proizvodi koji su na popustu (Loren)

CREATE VIEW proizvodi_na_popustu AS
SELECT 
    p.id AS proizvod_id,
    p.naziv AS proizvod_naziv,
    p.opis AS proizvod_opis,
    p.cijena AS originalna_cijena,
    (p.cijena - (p.cijena * pop.postotak_popusta / 100)) AS cijena_sa_popustom,
    pop.postotak_popusta,
    pop.datum_pocetka,
    pop.datum_zavrsetka
FROM 
    proizvodi p
JOIN 
    popusti pop ON p.id = pop.proizvod_id
WHERE 
    CURRENT_DATE BETWEEN pop.datum_pocetka AND pop.datum_zavrsetka
ORDER BY 
    pop.postotak_popusta DESC;

/*
SELECT * FROM proizvodi_na_popustu;
*/

-- Upit: Proizvodi koji su dostupni na skladištu, imaju više od 10 recenzija i prosječnu ocjenu iznad 4  (Loren)

SELECT 
    p.id AS proizvod_id, 
    p.naziv AS proizvod, 
    p.kolicina_na_skladistu, 
    COUNT(r.id) AS broj_recenzija, 
    AVG(r.ocjena) AS prosjecna_ocjena
FROM proizvodi p
LEFT JOIN recenzije_proizvoda r ON p.id = r.proizvod_id
WHERE p.kolicina_na_skladistu > 0
GROUP BY p.id, p.naziv, p.kolicina_na_skladistu
HAVING broj_recenzija > 10 AND prosjecna_ocjena > 4;

-- Upit: Proizvodi s najvećom i najmanjom cijenom po kategoriji (Loren)

SELECT 
    k.naziv AS kategorija, 
    MAX(p.cijena) AS najskuplji_proizvod, 
    MIN(p.cijena) AS najjeftiniji_proizvod
FROM proizvodi p
JOIN kategorije_proizvoda k ON p.kategorija_id = k.id
GROUP BY k.naziv;

-- Upit: Korisnici koji su napisali najviše recenzija i njihove prosječne ocjene (Loren)

SELECT 
    k.id AS korisnik_id, 
    k.ime, 
    k.prezime, 
    COUNT(r.id) AS broj_recenzija, 
    AVG(r.ocjena) AS prosjecna_ocjena
FROM korisnici k
JOIN recenzije_proizvoda r ON k.id = r.korisnik_id
GROUP BY k.id, k.ime, k.prezime
ORDER BY broj_recenzija DESC
LIMIT 5;

-- Upit: Prosječna ocjena proizvoda na temelju recenzija (Loren)

SELECT 
    p.id AS proizvod_id,
    p.naziv AS proizvod_naziv,
    p.opis AS proizvod_opis,
    AVG(r.ocjena) AS prosjecna_ocjena,
    COUNT(r.id) AS broj_recenzija
FROM 
    proizvodi p
LEFT JOIN 
    recenzije_proizvoda r ON p.id = r.proizvod_id
GROUP BY 
    p.id, p.naziv, p.opis
ORDER BY 
    prosjecna_ocjena DESC;


-- Okidač: Obavijest o niskoj zalihi spremju se u privremenu tablicu (Loren)


CREATE TEMPORARY TABLE privremene_obavijesti (
    poruka TEXT,
    vrijeme_kreiranja DATETIME
);

DELIMITER //
CREATE TRIGGER au_ObavijestNiskaZaliha
AFTER UPDATE ON proizvodi
FOR EACH ROW
BEGIN
    IF NEW.kolicina_na_skladistu < 5 THEN
        INSERT INTO privremene_obavijesti (poruka, vrijeme_kreiranja)
        VALUES (
            CONCAT('Upozorenje: Zaliha za proizvod "', NEW.naziv, '" je pala ispod 5.'),
            NOW()
        );
    END IF;
END //
DELIMITER ;

DROP TEMPORARY TABLE IF EXISTS privremene_obavijesti;

/*
UPDATE proizvodi 
SET kolicina_na_skladistu = 3
WHERE id = 2;

SELECT * FROM privremene_obavijesti;

SELECT * FROM proizvodi WHERE id = 2;
*/

-- Okidač: Ne dopušta recenziju ako korisnik nije kupio proizvod i ako je već napisao recenziju za taj proizvod (Loren)

DELIMITER //
CREATE TRIGGER bi_RestrikcijaRecenzije
BEFORE INSERT ON recenzije_proizvoda
FOR EACH ROW
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM stavke_narudzbe sn
        JOIN narudzbe n ON sn.narudzba_id = n.id
        WHERE sn.proizvod_id = NEW.proizvod_id AND n.korisnik_id = NEW.korisnik_id
    ) THEN
        SIGNAL SQLSTATE '45505'
        SET MESSAGE_TEXT = 'Korisnik nije kupio ovaj proizvod i ne može ostaviti recenziju.';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM recenzije_proizvoda
        WHERE proizvod_id = NEW.proizvod_id AND korisnik_id = NEW.korisnik_id
    ) THEN
        SIGNAL SQLSTATE '45506'
        SET MESSAGE_TEXT = 'Korisnik je već ostavio recenziju za ovaj proizvod.';
    END IF;
END //
DELIMITER ;

/*
INSERT INTO recenzije_proizvoda (proizvod_id, korisnik_id, ocjena, komentar) VALUES 
	(1, 2, 5, 'Odličan proizvod!');
*/

-- Okidač: Automatsko ažuriranje količine na skladištu (Loren)

DELIMITER //

CREATE TRIGGER azuriraj_kolicinu_na_skladistu
AFTER INSERT ON stavke_narudzbe
FOR EACH ROW
BEGIN
    IF (SELECT kolicina_na_skladistu FROM proizvodi WHERE id = NEW.proizvod_id) < NEW.kolicina THEN
        SIGNAL SQLSTATE '45513'
        SET MESSAGE_TEXT = 'Nedovoljna količina proizvoda na skladištu.';
    END IF;

    UPDATE proizvodi
    SET kolicina_na_skladistu = kolicina_na_skladistu - NEW.kolicina
    WHERE id = NEW.proizvod_id;
END //

DELIMITER ;

/*
INSERT INTO stavke_narudzbe (narudzba_id, proizvod_id, kolicina)
VALUES (30, 1, 5);
SELECT * FROM stavke_narudzbe;
SELECT * FROM proizvodi WHERE id = 1;
*/


-- Funkcija: Vraća ukupnu vrijednost svih proizvoda na skladištu (Loren)


DELIMITER //
CREATE FUNCTION UkupnaVrijednostSkladista ()
RETURNS DECIMAL(15,2)
DETERMINISTIC
BEGIN
    DECLARE ukupna_vrijednost DECIMAL(15,2);
    
    SELECT SUM(kolicina_na_skladistu * cijena)
    INTO ukupna_vrijednost
    FROM proizvodi;
       
    RETURN ukupna_vrijednost;
END //
DELIMITER ;

/*
SELECT UkupnaVrijednostSkladista();
*/

-- Funkcija: Funkcija za provjeru dostupnosti proizvoda na skladištu (Loren)

DELIMITER //

CREATE FUNCTION provjeri_dostupnost(
    p_proizvod_id INT,
    p_kolicina INT
)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE v_kolicina_na_skladistu INT;

    SELECT kolicina_na_skladistu
    INTO v_kolicina_na_skladistu
    FROM proizvodi
    WHERE id = p_proizvod_id;

    IF v_kolicina_na_skladistu IS NULL THEN
        RETURN FALSE;
    END IF;

    IF p_kolicina > v_kolicina_na_skladistu THEN
        RETURN FALSE;
    END IF;

    RETURN TRUE;
END //

DELIMITER ;

/*
SELECT provjeri_dostupnost(1, 51) AS dostupno;
*/




-- Funkcija: Funkcija za izračunavanje prosječne ocjene proizvoda na temelju recenzija (Loren)

DELIMITER //

CREATE FUNCTION prosjecna_ocjena_proizvoda(
    p_proizvod_id INT
)
RETURNS DECIMAL(3, 2)
DETERMINISTIC
BEGIN
    DECLARE v_prosjecna_ocjena DECIMAL(3, 2);

    SELECT AVG(ocjena)
    INTO v_prosjecna_ocjena
    FROM recenzije_proizvoda
    WHERE proizvod_id = p_proizvod_id;

    RETURN v_prosjecna_ocjena;
END //

DELIMITER ;

/*
SELECT prosjecna_ocjena_proizvoda(1) AS prosjecna_ocjena;
*/


-- Procedura:Procedura za brisanje proizvoda s provjerom povezanih podataka (Loren)


DELIMITER //
CREATE PROCEDURE ObrisiProizvod (
    IN p_proizvod_id INT
)
BEGIN

    IF EXISTS (
        SELECT *
        FROM stavke_narudzbe
        WHERE proizvod_id = p_proizvod_id
    ) THEN
        SIGNAL SQLSTATE '45503'
        SET MESSAGE_TEXT = 'Proizvod ne može biti obrisan jer postoje povezane narudžbe.';
    ELSE

        DELETE FROM popusti
        WHERE proizvod_id = p_proizvod_id;

        DELETE FROM recenzije_proizvoda
        WHERE proizvod_id = p_proizvod_id;

        DELETE FROM wishlist
        WHERE proizvod_id = p_proizvod_id;

        DELETE FROM proizvodi
        WHERE id = p_proizvod_id;
    END IF;
END //
DELIMITER ;

/*
CALL ObrisiProizvod(1);
*/


-- Procedura: Dodavanje proizvoda s provjerom grešaka (Loren)

DELIMITER //
CREATE PROCEDURE DodajProizvod (
    IN p_naziv VARCHAR(255),
    IN p_opis TEXT,
    IN p_cijena DECIMAL(10, 2),
    IN p_kategorija_id INT,
    IN p_kolicina INT,
    IN p_slika VARCHAR(255),
    IN p_specifikacije TEXT
)
BEGIN
  
    IF p_cijena <= 0 THEN
        SIGNAL SQLSTATE '45501'
        SET MESSAGE_TEXT = 'Cijena mora biti veća od 0.';
    ELSEIF p_kolicina < 0 THEN
        SIGNAL SQLSTATE '45502'
        SET MESSAGE_TEXT = 'Količina na skladištu ne može biti negativna.';
    ELSE
 
        INSERT INTO proizvodi (naziv, opis, cijena, kategorija_id, kolicina_na_skladistu, slika, specifikacije)
        VALUES (p_naziv, p_opis, p_cijena, p_kategorija_id, p_kolicina, p_slika, p_specifikacije);
    END IF;
END //
DELIMITER ;

/*
CALL DodajProizvod('Test Proizvod', 'Opis proizvoda', 10, 1, -1, 'slika.jpg', 'Specifikacije');
CALL DodajProizvod('Test Proizvod', 'Opis proizvoda', -21, 1, 12, 'slika.jpg', 'Specifikacije');
*/

-- Procedura: Pronalazi proizvode s ključnom riječi (Loren)

DELIMITER //
CREATE PROCEDURE PronadjiProizvode (
    IN kljucna_rijec VARCHAR(255)
)
BEGIN
    SELECT * 
    FROM proizvodi
    WHERE naziv LIKE CONCAT('%', kljucna_rijec, '%')
       OR opis LIKE CONCAT('%', kljucna_rijec, '%');
END //
DELIMITER ;

/*
CALL PronadjiProizvode('računalo');
*/



-- Procedura: Procedura ima mogućnost ažuriranja svih podataka vezanih za neki proizvod. (Loren)


DELIMITER //

CREATE PROCEDURE azuriraj_proizvod(
    IN p_proizvod_id INT,
    IN p_naziv VARCHAR(255),
    IN p_opis TEXT,
    IN p_cijena DECIMAL(10, 2),
    IN p_kategorija_id INT,
    IN p_kolicina_na_skladistu INT,
    IN p_slika VARCHAR(255),
    IN p_specifikacije TEXT
)
BEGIN
    IF p_cijena <= 0 THEN
        SIGNAL SQLSTATE '45501'
        SET MESSAGE_TEXT = 'Cijena mora biti veća od 0.';
    END IF;

    IF p_kolicina_na_skladistu < 0 THEN
        SIGNAL SQLSTATE '45502'
        SET MESSAGE_TEXT = 'Količina na skladištu ne može biti negativna.';
    END IF;

    IF NOT EXISTS (SELECT * FROM kategorije_proizvoda WHERE id = p_kategorija_id) THEN
        SIGNAL SQLSTATE '45509'
        SET MESSAGE_TEXT = 'Kategorija s unesenim ID ne postoji.';
    END IF;

    IF NOT EXISTS (SELECT * FROM proizvodi WHERE id = p_proizvod_id) THEN
        SIGNAL SQLSTATE '45510'
        SET MESSAGE_TEXT = 'Proizvod s unesenim ID ne postoji.';
    END IF;

    UPDATE proizvodi
    SET naziv = p_naziv,
        opis = p_opis,
        cijena = p_cijena,
        kategorija_id = p_kategorija_id,
        kolicina_na_skladistu = p_kolicina_na_skladistu,
        slika = p_slika,
        specifikacije = p_specifikacije
    WHERE id = p_proizvod_id;
END //

DELIMITER ;



/*
INSERT INTO proizvodi (id, naziv, opis, cijena, kategorija_id, kolicina_na_skladistu, slika, specifikacije, datum_kreiranja) VALUES
	(826, 'Televizor', 'Smart TV', 500.00, 1, 10, 'smart_tv.jpg', '4K, Smart TV, OS:Android', '2024-11-16');

SELECT * FROM proizvodi WHERE id = 826;

CALL azuriraj_proizvod(826, 'Televizor Philips', '4K Smart TV', 550.00, 1, 11, 'slike/tv.jpg', 'Ultra HD 4K , OS:Android');
*/

-- Procedura:Procedura za dodavanje kategorije proizvoda (Loren)

DELIMITER //

CREATE PROCEDURE dodaj_kategoriju_proizvoda(
    IN p_naziv VARCHAR(255),
    IN p_opis TEXT
)
BEGIN
    IF EXISTS (SELECT * FROM kategorije_proizvoda WHERE naziv = p_naziv) THEN
        SIGNAL SQLSTATE '45504'
        SET MESSAGE_TEXT = 'Kategorija s unesenim nazivom već postoji.';
    END IF;

    INSERT INTO kategorije_proizvoda (naziv, opis)
    VALUES (p_naziv, p_opis);
END //

DELIMITER ;

/*
CALL dodaj_kategoriju_proizvoda('Televizori', 'Različiti modeli televizija');
SELECT * FROM kategorije_proizvoda;
*/

-- Procedura:Procedura za ažuriranje kategorije proizvoda (Loren)

DELIMITER //

CREATE PROCEDURE azuriraj_kategoriju_proizvoda(
    IN p_kategorija_id INT,
    IN p_naziv VARCHAR(255),
    IN p_opis TEXT
)
BEGIN
    IF NOT EXISTS (SELECT * FROM kategorije_proizvoda WHERE id = p_kategorija_id) THEN
        SIGNAL SQLSTATE '45509'
        SET MESSAGE_TEXT = 'Kategorija s unesenim ID ne postoji.';
    END IF;

    IF EXISTS (
        SELECT * FROM kategorije_proizvoda 
        WHERE naziv = p_naziv AND id != p_kategorija_id
    ) THEN
        SIGNAL SQLSTATE '45504'
        SET MESSAGE_TEXT = 'Kategorija s unesenim nazivom već postoji.';
    END IF;

    UPDATE kategorije_proizvoda
    SET naziv = p_naziv,
        opis = p_opis
    WHERE id = p_kategorija_id;
END //

DELIMITER ;

/*
CALL azuriraj_kategoriju_proizvoda(31, 'TV', 'Ažurirani opis');
SELECT * FROM kategorije_proizvoda;
*/

-- Procedura: Procedura za brisanje kategorije proizvoda (Loren)

DELIMITER //

CREATE PROCEDURE obrisi_kategoriju_proizvoda(
    IN p_kategorija_id INT
)
BEGIN
    IF NOT EXISTS (SELECT * FROM kategorije_proizvoda WHERE id = p_kategorija_id) THEN
        SIGNAL SQLSTATE '45509'
        SET MESSAGE_TEXT = 'Kategorija s unesenim ID ne postoji.';
    END IF;
    IF EXISTS (SELECT * FROM proizvodi WHERE kategorija_id = p_kategorija_id) THEN
        SIGNAL SQLSTATE '45507'
        SET MESSAGE_TEXT = 'Nije moguće obrisati kategoriju jer postoje proizvodi povezani s njom.';
    END IF;

    DELETE FROM kategorije_proizvoda
    WHERE id = p_kategorija_id;
END //

DELIMITER ;

/*
CALL obrisi_kategoriju_proizvoda(31);
*/

-- Procedura: Procedura za unos recenzije proizvoda (Loren)

DELIMITER //

CREATE PROCEDURE dodaj_recenziju_proizvoda(
    IN p_proizvod_id INT,
    IN p_korisnik_id INT,
    IN p_ocjena INT,
    IN p_komentar TEXT
)
BEGIN
    IF NOT EXISTS (SELECT * FROM proizvodi WHERE id = p_proizvod_id) THEN
        SIGNAL SQLSTATE '45510'
        SET MESSAGE_TEXT = 'Proizvod s unesenim ID ne postoji.';
    END IF;

    IF NOT EXISTS (SELECT * FROM korisnici WHERE id = p_korisnik_id) THEN
        SIGNAL SQLSTATE '45508'
        SET MESSAGE_TEXT = 'Korisnik s unesenim ID ne postoji.';
    END IF;

    IF p_ocjena < 1 OR p_ocjena > 5 THEN
        SIGNAL SQLSTATE '45511'
        SET MESSAGE_TEXT = 'Ocjena mora biti između 1 i 5.';
    END IF;

    IF EXISTS (
        SELECT * FROM recenzije_proizvoda 
        WHERE proizvod_id = p_proizvod_id AND korisnik_id = p_korisnik_id
    ) THEN
        SIGNAL SQLSTATE '45506'
        SET MESSAGE_TEXT = 'Korisnik je već ostavio recenziju za ovaj proizvod.';
    END IF;

    INSERT INTO recenzije_proizvoda (proizvod_id, korisnik_id, ocjena, komentar)
    VALUES (p_proizvod_id, p_korisnik_id, p_ocjena, p_komentar);
END //

DELIMITER ;

/*
SELECT * FROM recenzije_proizvoda;
CALL dodaj_recenziju_proizvoda(101, 1, 5, 'Odličan proizvod!');
SELECT * FROM stavke_narudzbe;
*/

-- Procedura: Procedura za ažuriranje recenzije proizvoda (Loren)

DELIMITER //

CREATE PROCEDURE azuriraj_recenziju_proizvoda(
    IN p_recenzija_id INT,
    IN p_ocjena INT,
    IN p_komentar TEXT
)
BEGIN
    IF NOT EXISTS (SELECT * FROM recenzije_proizvoda WHERE id = p_recenzija_id) THEN
        SIGNAL SQLSTATE '45512'
        SET MESSAGE_TEXT = 'Recenzija s unesenim ID ne postoji.';
    END IF;

    IF p_ocjena < 1 OR p_ocjena > 5 THEN
        SIGNAL SQLSTATE '45511'
        SET MESSAGE_TEXT = 'Ocjena mora biti između 1 i 5.';
    END IF;

    UPDATE recenzije_proizvoda
    SET ocjena = p_ocjena,
        komentar = p_komentar,
        datum_recenzije = CURRENT_TIMESTAMP
    WHERE id = p_recenzija_id;
END //

DELIMITER ;

/*
SELECT * FROM recenzije_proizvoda;

CALL azuriraj_recenziju_proizvoda(33, 4, 'Proizvod je dobar, ali ima nekih nedostataka.');
*/

-- Procedura: Procedura za brisanje recenzije proizvoda (Loren)

DELIMITER //

CREATE PROCEDURE obrisi_recenziju_proizvoda(
    IN p_recenzija_id INT
)
BEGIN
    IF NOT EXISTS (SELECT * FROM recenzije_proizvoda WHERE id = p_recenzija_id) THEN
        SIGNAL SQLSTATE '45512'
        SET MESSAGE_TEXT = 'Recenzija s unesenim ID ne postoji.';
    END IF;

    DELETE FROM recenzije_proizvoda
    WHERE id = p_recenzija_id;
END //

DELIMITER ;

/*
CALL obrisi_recenziju_proizvoda(33);
*/




-- Pogled: Prikazuje stavke u košarici korsinika: (Morena)
CREATE VIEW pogled_kosarica_korisnika AS
SELECT 
    k.id AS kosarica_id,
    k.korisnik_id,
    k.proizvod_id,
    p.naziv AS proizvod_naziv,
    p.cijena AS proizvod_cijena,
    k.kolicina AS proizvod_kolicina,
    (k.kolicina * p.cijena) AS ukupna_cijena
FROM 
    kosarica k
JOIN 
    proizvodi p ON k.proizvod_id = p.id;
    
-- Pogled:prikazuje sve narudžbe korisnika zajedno s detaljima o stavkama narudžbi, uključujući količinu proizvoda i ukupnu cijenu: (Morena)
CREATE VIEW pogled_narudzbi_korisnika AS
SELECT 
    n.id AS narudzba_id,
    n.datum_narudzbe,
    n.status_narudzbe,
    n.ukupna_cijena,
    n.nacin_isporuke_id,
    n.kupon_id,
    s.proizvod_id,
    p.naziv AS proizvod_naziv,
    s.kolicina AS proizvod_kolicina,
    p.cijena AS proizvod_cijena,
    (s.kolicina * p.cijena) AS ukupna_cijena_stavke
FROM 
    narudzbe n
JOIN 
    stavke_narudzbe s ON n.id = s.narudzba_id
JOIN 
    proizvodi p ON s.proizvod_id = p.id;
    
-- procedura:omogućuje korisnicima da stvore novu narudžbu. Unosi korisnika, odabrani način isporuke, 
-- i kupon (ako postoji), a zatim automatski dodaje stavke iz košarice u narudžbu. (Morena)


SET @narudzba_id=NULL;

DELIMITER //

CREATE PROCEDURE kreiraj_narudzbu(
    IN p_korisnik_id INT,
    IN p_nacin_isporuke_id INT,
    IN p_kupon_id INT,
    OUT p_narudzba_id INT
)
BEGIN
    DECLARE v_ukupna_cijena DECIMAL(10, 2) DEFAULT 0.00;
    
    SELECT SUM(p.cijena * k.kolicina) INTO v_ukupna_cijena
    FROM kosarica k
    JOIN proizvodi p ON k.proizvod_id = p.id
    WHERE k.korisnik_id = p_korisnik_id;
  
    INSERT INTO narudzbe (korisnik_id, datum_narudzbe, status_narudzbe, ukupna_cijena, nacin_isporuke_id, kupon_id)
    VALUES (p_korisnik_id, CURRENT_DATE, 'u obradi', v_ukupna_cijena, p_nacin_isporuke_id, p_kupon_id);
 
    SET p_narudzba_id = LAST_INSERT_ID();
    
    INSERT INTO stavke_narudzbe (narudzba_id, proizvod_id, kolicina)
    SELECT p_narudzba_id, k.proizvod_id, k.kolicina
    FROM kosarica k
    WHERE k.korisnik_id = p_korisnik_id;
  
    DELETE FROM kosarica WHERE korisnik_id = p_korisnik_id;
END //
DELIMITER ; 



-- procedura:omogućuje administraciji da ažurira status narudžbe (npr. 'u obradi', 'poslano', 'dostavljeno') prema ID-u narudžbe. (Morena)

DELIMITER //

CREATE PROCEDURE azuriraj_status_narudzbe(
    IN p_narudzba_id INT,
    IN p_status_narudzbe ENUM('u obradi', 'poslano', 'dostavljeno')
)
BEGIN
    -- Ažuriraj status narudžbe
    UPDATE narudzbe
    SET status_narudzbe = p_status_narudzbe
    WHERE id = p_narudzba_id;

END //

DELIMITER ;

-- procedura:omogućuje korisnicima dodavanje stavke u svoju košaricu, povećavajući količinu proizvoda u košarici ako je proizvod već prisutan.(Morena)

DELIMITER //

CREATE PROCEDURE dodaj_u_kosaricu(
    IN p_korisnik_id INT,
    IN p_proizvod_id INT,
    IN p_kolicina INT
)
BEGIN
    DECLARE v_kolicina INT;
  
    SELECT kolicina INTO v_kolicina
    FROM kosarica
    WHERE korisnik_id = p_korisnik_id AND proizvod_id = p_proizvod_id;
    
    IF v_kolicina IS NOT NULL THEN
        UPDATE kosarica
        SET kolicina = kolicina + p_kolicina
        WHERE korisnik_id = p_korisnik_id AND proizvod_id = p_proizvod_id;
    ELSE
        INSERT INTO kosarica (korisnik_id, proizvod_id, kolicina)
        VALUES (p_korisnik_id, p_proizvod_id, p_kolicina);
    END IF;
END //

DELIMITER ;

-- procedura:omogućuje korisnicima dodavanje stavke u svoju košaricu, povećavajući količinu proizvoda u košarici ako je proizvod već prisutan.(Morena)


DELIMITER // 
CREATE PROCEDURE dodaj_proizvod_u_kosaricu( IN p_korisnik_id INT, IN p_proizvod_id INT, IN p_kolicina INT ) 
BEGIN DECLARE v_kolicina_na_skladistu INT; 
DECLARE v_postojeca_kolicina INT DEFAULT 0; 

SELECT kolicina_na_skladistu INTO v_kolicina_na_skladistu 
FROM proizvodi 
WHERE id = p_proizvod_id; 

IF v_kolicina_na_skladistu IS NULL 
THEN SIGNAL SQLSTATE '45300' SET MESSAGE_TEXT = 'Proizvod s navedenim ID-em ne postoji.'; 
ELSEIF v_kolicina_na_skladistu < p_kolicina 
THEN SIGNAL SQLSTATE '45300' SET MESSAGE_TEXT = 'Nedovoljna količina proizvoda na skladištu.'; 
ELSE 

SELECT kolicina INTO v_postojeca_kolicina 
FROM kosarica 
WHERE korisnik_id = p_korisnik_id AND proizvod_id = p_proizvod_id; 

IF v_postojeca_kolicina > 0 
THEN UPDATE kosarica SET kolicina = kolicina + p_kolicina 
WHERE korisnik_id = p_korisnik_id AND proizvod_id = p_proizvod_id; 
ELSE 
 
INSERT INTO kosarica (korisnik_id, proizvod_id, kolicina) VALUES (p_korisnik_id, p_proizvod_id, p_kolicina); 
END IF; 
 
UPDATE proizvodi SET kolicina_na_skladistu = kolicina_na_skladistu - p_kolicina 
WHERE id = p_proizvod_id; 
END IF; 
END; // 
DELIMITER ;

-- procedura:za ažuriranje proizvoda u košarici (Morena)

DELIMITER // 
CREATE PROCEDURE azuriraj_proizvod_u_kosarici( IN p_korisnik_id INT, IN p_proizvod_id INT, IN p_nova_kolicina INT ) 
BEGIN 
DECLARE v_trenutna_kolicina INT DEFAULT 0; 
DECLARE v_kolicina_na_skladistu INT DEFAULT 0; 
DECLARE v_razlika INT; 

SELECT kolicina INTO v_trenutna_kolicina 
FROM kosarica 
WHERE korisnik_id = p_korisnik_id AND proizvod_id = p_proizvod_id; 

IF v_trenutna_kolicina IS NULL 
THEN SIGNAL SQLSTATE '45310' SET MESSAGE_TEXT = 'Proizvod nije pronađen u košarici.'; 
END IF; 

SELECT kolicina_na_skladistu INTO v_kolicina_na_skladistu 
FROM proizvodi 
WHERE id = p_proizvod_id; 

SET v_razlika = p_nova_kolicina - v_trenutna_kolicina; 

IF v_razlika > 0 
THEN IF v_razlika > v_kolicina_na_skladistu 
THEN SIGNAL SQLSTATE '45311' SET MESSAGE_TEXT = 'Nedovoljna količina proizvoda na skladištu za ažuriranje.'; 
END IF; 

UPDATE proizvodi 
SET kolicina_na_skladistu = kolicina_na_skladistu - v_razlika 
WHERE id = p_proizvod_id; 

ELSEIF v_razlika < 0 
THEN UPDATE proizvodi 
SET kolicina_na_skladistu = kolicina_na_skladistu + ABS(v_razlika) WHERE id = p_proizvod_id; 
END IF; 

UPDATE kosarica 
SET kolicina = p_nova_kolicina 
WHERE korisnik_id = p_korisnik_id AND proizvod_id = p_proizvod_id; 
END; // 
DELIMITER ;

-- procedura:za brisanje proizvoda iz košarice (Morena)

DELIMITER // 
CREATE PROCEDURE obrisi_proizvod_iz_kosarice( IN p_korisnik_id INT, IN p_proizvod_id INT ) 
BEGIN DECLARE v_kolicina_u_kosarici INT DEFAULT 0; 

 SELECT kolicina INTO v_kolicina_u_kosarici 
FROM kosarica 
WHERE korisnik_id = p_korisnik_id AND proizvod_id = p_proizvod_id;
 
 IF v_kolicina_u_kosarici 
IS NULL THEN SIGNAL SQLSTATE '45312' SET MESSAGE_TEXT = 'Proizvod nije pronađen u košarici.'; 
END IF; 

UPDATE proizvodi 
SET kolicina_na_skladistu = kolicina_na_skladistu + v_kolicina_u_kosarici 
WHERE id = p_proizvod_id; 
 
DELETE FROM kosarica 
WHERE korisnik_id = p_korisnik_id AND proizvod_id = p_proizvod_id;
 END; // 
DELIMITER ;



-- Okidač: Status isporuke određene narudžbe: (Morena)
DELIMITER //

CREATE TRIGGER dodaj_pracenje_nakon_narudzbe
AFTER INSERT ON narudzbe
FOR EACH ROW
BEGIN
    INSERT INTO pracenje_isporuka (narudzba_id, status_isporuke, datum_isporuke)
    VALUES (NEW.id, 'u pripremi', NULL);
END//

DELIMITER ;


-- okidač: automatski ažurira status narudžbe u tablici narudzbe na 'dostavljeno' kada se status isporuke u tablici pracenje_isporuka 
-- promijeni na 'dostavljeno'.(Morena)

DELIMITER //

CREATE TRIGGER azuriraj_status_narudzbe_na_dostavljeno
AFTER UPDATE ON pracenje_isporuka
FOR EACH ROW
BEGIN
    IF NEW.status_isporuke = 'dostavljeno' THEN
       
        UPDATE narudzbe
        SET status_narudzbe = 'dostavljeno'
        WHERE id = NEW.narudzba_id;
    END IF;
END //

DELIMITER ;

-- okidač: automatski ažurira status narudžbe u tablici narudzbe na 'poslano' kada se status isporuke u tablici pracenje_isporuka 
-- promijeni na 'poslano'.(Morena)

DELIMITER //

CREATE TRIGGER azuriraj_status_narudzbe_na_poslano
AFTER UPDATE ON pracenje_isporuka
FOR EACH ROW
BEGIN
    IF NEW.status_isporuke = 'poslano' THEN
       
        UPDATE narudzbe
        SET status_narudzbe = 'poslano'
        WHERE id = NEW.narudzba_id;
    END IF;
END //

DELIMITER ;

-- okidač: automatski vraća količinu proizvoda na skladište kada se povrati proizvod (kad se doda zapis u tablicu povrati_proizvoda).(Morena)

DELIMITER //

CREATE TRIGGER povrat_proizvoda_skladiste
AFTER INSERT ON povrati_proizvoda
FOR EACH ROW
BEGIN
   
    UPDATE proizvodi
    SET kolicina_na_skladistu = kolicina_na_skladistu + (SELECT kolicina FROM stavke_narudzbe WHERE id = NEW.stavka_id)
    WHERE id = (SELECT proizvod_id FROM stavke_narudzbe WHERE id = NEW.stavka_id);
END //

DELIMITER ;

-- upit: vraća sve narudžbe određenog korisnika, uključujući podatke o proizvodima i količinama u narudžbi(dan je primjer sa korisnikom 
-- čiji je ID=1). (Morena)

SELECT 
    n.id AS narudzba_id,
    n.datum_narudzbe,
    n.status_narudzbe,
    n.ukupna_cijena,
    sn.proizvod_id,
    p.naziv AS proizvod_naziv,
    sn.kolicina AS proizvod_kolicina
FROM narudzbe n
JOIN stavke_narudzbe sn ON n.id = sn.narudzba_id
JOIN proizvodi p ON sn.proizvod_id = p.id
WHERE n.korisnik_id = 1;

-- upit: prikazuje sve proizvode u košarici određenog korisnika s količinama.(Dan je primjer sa korisnikom čiji je ID=1)(Morena)

SELECT 
    k.id AS kosarica_id,
    k.proizvod_id,
    p.naziv AS proizvod_naziv,
    k.kolicina AS proizvod_kolicina,
    p.cijena * k.kolicina AS ukupna_cijena
FROM kosarica k
JOIN proizvodi p ON k.proizvod_id = p.id
WHERE k.korisnik_id = 1;


-- Upita za provjeru trenutnog statusa narudžbe i isporuke na temelju ID-a narudžbe (Morena)

SELECT n.id AS narudzba_id, 
	n.status_narudzbe,
	p.status_isporuke,
	p.datum_isporuke, 
	n.datum_narudzbe,
	n.ukupna_cijena,
	n.nacin_isporuke_id
FROM narudzbe n
LEFT JOIN pracenje_isporuka p 
ON n.id = p.narudzba_id 
WHERE n.id =1 ;

-- Upit za prikaz najprodavanijih proizvoda koji se nalaze u stavke_narudzbe (Morena)

SELECT p.id AS proizvod_id,
 	 p.naziv AS naziv_proizvoda, 
 SUM(sn.kolicina) AS ukupno_prodano 
FROM stavke_narudzbe sn 
JOIN proizvodi p ON sn.proizvod_id = p.id 
GROUP BY p.id, p.naziv 
ORDER BY ukupno_prodano DESC 
LIMIT 5;

-- funkcija: vraća broj proizvoda u košarici određenog korisnika. Broj proizvoda je zbroj svih količina proizvoda u košarici. (Morena)

DELIMITER //

CREATE FUNCTION brojProizvodaUKosarici(korisnikId INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE brojProizvoda INT DEFAULT 0;

    SELECT SUM(kolicina) INTO brojProizvoda
    FROM kosarica
    WHERE korisnik_id = korisnikId;

    RETURN brojProizvoda;
END//

DELIMITER ;

SELECT brojProizvodaUKosarici(1)

-- funkcija: izračunava ukupnu cijenu narudžbe na temelju stavki narudžbe. Uzimajući u obzir količinu proizvoda i 
-- cijenu svakog proizvoda, funkcija vraća ukupnu cijenu za zadanu narudžbu.(Morena)

DELIMITER //

CREATE FUNCTION izracunajUkupnuCijenuNarudzbe(narudzbaId INT)
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE ukupnaCijena DECIMAL(10, 2) DEFAULT 0.00;

    SELECT SUM(p.cijena * sn.kolicina) INTO ukupnaCijena
    FROM stavke_narudzbe sn
    JOIN proizvodi p ON sn.proizvod_id = p.id
    WHERE sn.narudzba_id = narudzbaId;

    RETURN ukupnaCijena;
END//

DELIMITER ;

SELECT izracunajUkupnuCijenuNarudzbe(1);





########## Bruno #########

-- Upiti (Bruno)

-- Prikaži sve narudžbe gdje se narudžba isporučila u manje od 3 dana (uključujući i preuzimanje) (Bruno)
SELECT *
	FROM narudzbe
    INNER JOIN (SELECT *
				 FROM nacini_isporuke
                 WHERE trajanje < 3) AS temp_nacini_isporuke 
    ON narudzbe.nacin_isporuke_id = temp_nacini_isporuke.id
    HAVING narudzbe.status_narudzbe = "dostavljeno";


-- Prikaži sve proizvode koji su bili sniženi 20% ili više u zadnjih godinu dana (Bruno)
SELECT proizvodi.*, temp_popusti.postotak_popusta, temp_popusti.datum_pocetka, temp_popusti.datum_zavrsetka
	FROM proizvodi
    INNER JOIN (SELECT *
					FROM popusti
					WHERE (postotak_popusta >= 20 AND datum_zavrsetka > CURDATE() - INTERVAL 1 YEAR)) AS temp_popusti
    ON proizvodi.id = temp_popusti.proizvod_id;


-- Prikaži broj kupaca koji su preuzeli svoju narudzbu u trgovini (Bruno)
SELECT COUNT(*) AS broj_kupaca
	FROM narudzbe
    INNER JOIN (SELECT id
					FROM nacini_isporuke
                    WHERE trajanje = 0) AS temp_nacini_isporuke
				ON narudzbe.nacin_isporuke_id = temp_nacini_isporuke.id
                GROUP BY temp_nacini_isporuke.id;


    
-- Pogledi (Bruno)
-- Napravi pogled koji prikazuje sve proizvode sa sniženom cijenom kad se primjeni popust (Bruno)
CREATE VIEW proizvodi_sa_snizenom_cijenom AS
SELECT proizvodi.*, ROUND((cijena * (1 - popusti.postotak_popusta / 100)), 2) AS snizena_cijena
	FROM popusti
    INNER JOIN proizvodi ON popusti.proizvod_id = proizvodi.id;

SELECT * FROM proizvodi_sa_snizenom_cijenom;


-- Napravi pogled koji prikazuje trenutno aktivne popuste na proizvodima (Bruno)
CREATE VIEW proizvodi_sa_aktivnim_popustom AS
SELECT proizvodi.*, popusti.postotak_popusta, popusti.datum_pocetka, popusti.datum_zavrsetka
	FROM popusti
    INNER JOIN proizvodi ON proizvodi.id = popusti.proizvod_id
    HAVING datum_pocetka <= CURDATE() AND datum_zavrsetka >> CURDATE();

SELECT * FROM proizvodi_sa_aktivnim_popustom;



-- Funkcije (Bruno)

-- Funkcija koja računa konačnu cijenu proizvoda nakon popusta (Bruno)
DELIMITER //
CREATE FUNCTION cijena_s_popustom(cijena DECIMAL(10,2), postotak_popusta DECIMAL(5,2)) RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
	RETURN cijena * (1 - postotak_popusta / 100);
END //
DELIMITER ;

SELECT proizvodi.*, cijena_s_popustom(cijena, postotak_popusta) AS snizena_cijena
	FROM proizvodi
    INNER JOIN popusti ON proizvodi.id = popusti.proizvod_id;
    
    
-- Funkcija koja dohvaća naziv načina isporuke po unesenom ID-u (Bruno)
DELIMITER //
CREATE FUNCTION naziv_isporuke(isporuka_id INTEGER) RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
	DECLARE naziv_p VARCHAR(255);
    
    SELECT naziv INTO naziv_p
		FROM nacini_isporuke
        WHERE id = isporuka_id;
	
    RETURN naziv_p;
END //
DELIMITER ;

SELECT *, naziv_isporuke(nacin_isporuke_id) AS naziv_isporuke
	FROM narudzbe;
    

-- Funkcija koja računa koliko je pojedinih načina isporuke narudžbi (Bruno)
DELIMITER //
CREATE FUNCTION broj_nacina_isporuke(isporuka_id INTEGER) RETURNS INTEGER
DETERMINISTIC
BEGIN
	DECLARE broj INTEGER;
    
	SELECT COUNT(*) INTO broj
		FROM narudzbe
        WHERE nacin_isporuke_id = isporuka_id
        GROUP BY nacin_isporuke_id;
	
    RETURN broj;
END //
DELIMITER ;

SELECT *, broj_nacina_isporuke(id) AS broj_nacina_isporuke
	FROM nacini_isporuke;
    
    

-- Procedure (Bruno)
-- Procedura za dodavanje načina isporuke (Bruno)
DELIMITER //
CREATE PROCEDURE dodaj_nacin_isporuke(naziv_p VARCHAR(255), opis_p TEXT, cijena_p DECIMAL(10,2), trajanje_p INTEGER)
BEGIN
	DECLARE brojac INTEGER DEFAULT 0;
	SELECT COUNT(*) INTO brojac
		FROM nacini_isporuke
        WHERE naziv = naziv_p;
	
    IF brojac > 0 THEN
		SIGNAL SQLSTATE "45102" SET MESSAGE_TEXT = "Greška u unosu, način isporuke već postoji!";
	ELSE 
		INSERT INTO nacini_isporuke (naziv, opis, cijena, trajanje) VALUES (naziv_p, opis_p, cijena_p, trajanje_p);
	END IF;
    
END //
DELIMITER ;

/*
CALL dodaj_nacin_isporuke("Express dostava", "Dostava u roku 3 sata", 150, 0);
SELECT *
	FROM nacini_isporuke;
*/
    
-- Procedura za brisanje načina isporuke po ID-u (Bruno)
DELIMITER //
CREATE PROCEDURE obrisi_nacin_isporuke(id_p INTEGER)
BEGIN
	DECLARE brojac INTEGER DEFAULT 0;
	SELECT COUNT(*) INTO brojac
		FROM nacini_isporuke
        WHERE id = id_p;
	
    IF brojac = 0 THEN
		SIGNAL SQLSTATE "45102" SET MESSAGE_TEXT = "Greška u brisanju, način isporuke ne postoji!";
	ELSE 
		DELETE
			FROM nacini_isporuke
			WHERE id = id_p;
	END IF;

END //
DELIMITER ;

/*
CALL obrisi_nacin_isporuke(7);
SELECT *
	FROM nacini_isporuke;
*/

-- Procedura za dodavanje popusta (Bruno)
DELIMITER //
CREATE PROCEDURE dodaj_popust(proizvod_id_p INTEGER, postotak_popusta_p DECIMAL(5,2), datum_pocetka_p DATE, datum_zavrsetka_p DATE)
BEGIN
    INSERT INTO popusti (proizvod_id, postotak_popusta, datum_pocetka, datum_zavrsetka) VALUES (proizvod_id_p, postotak_popusta_p, datum_pocetka_p, datum_zavrsetka_p);
END //
DELIMITER ;

/*
CALL dodaj_popust(56, 30, '2025-01-01', '2025-01-10');
SELECT *
	FROM popusti;
*/
    
-- Procedura za brisanje popusta po ID-u (Bruno)
DELIMITER //
CREATE PROCEDURE obrisi_popust(id_p INTEGER)
BEGIN
	DECLARE brojac INTEGER DEFAULT 0;
	SELECT COUNT(*) INTO brojac
		FROM popusti
        WHERE id = id_p;
	
    IF brojac = 0 THEN
		SIGNAL SQLSTATE "45103" SET MESSAGE_TEXT = "Greška u brisanju, popust ne postoji!";
	ELSE 
		DELETE
			FROM popusti
			WHERE id = id_p;
	END IF;

END //
DELIMITER ;

/*
CALL obrisi_popust(41);
SELECT *
	FROM popusti;
*/
    
-- Procedura za ažuriranje popusta (Bruno)
DELIMITER //
CREATE PROCEDURE azuriraj_popust(popust_id INTEGER, novi_postotak DECIMAL(5,2))
BEGIN
	DECLARE brojac INTEGER DEFAULT 0;
	SELECT COUNT(*) INTO brojac
		FROM popusti
        WHERE id = popust_id;
	
    IF brojac = 0 THEN
		SIGNAL SQLSTATE "45103" SET MESSAGE_TEXT = "Greška u ažuriranju, popust ne postoji!";
	ELSE 
		UPDATE popusti SET postotak_popusta = novi_postotak WHERE id = popust_id;
	END IF;
END //
DELIMITER ;

/*
SELECT *
	FROM popusti;
CALL azuriraj_popust(41, 10);
*/

-- Okidači -- (Bruno)

-- Okidač koji osigurava da proizvod može imati samo jedan aktivni popust (Bruno)
DELIMITER //
CREATE TRIGGER bi_popusti
BEFORE INSERT ON popusti 
FOR EACH ROW 
BEGIN 
	DECLARE brojac INTEGER;
    
	SELECT COUNT(*) INTO brojac 
		FROM popusti 
		WHERE NEW.proizvod_id = proizvod_id AND NEW.datum_pocetka <= datum_zavrsetka AND NEW.datum_zavrsetka >= datum_pocetka; 
        
        
		IF brojac > 0 THEN 
		SIGNAL SQLSTATE '45100' 
		SET MESSAGE_TEXT = 'Popust za ovaj proizvod već postoji u 
		zadanom razdoblju.'; 
		END IF; 
        
END; //
DELIMITER ;

/*
-- provjera okidača
INSERT INTO popusti (proizvod_id, postotak_popusta, datum_pocetka, datum_zavrsetka) VALUES 
(1, 20.00, '2023-12-05', '2023-12-20');
*/


-- okidač koji osigurava automatsko brisanje popusta na proizvode kada istekne datum završetka (Bruno)
DELIMITER //
CREATE TRIGGER bi_1_popusti
BEFORE INSERT ON popusti 
FOR EACH ROW 
BEGIN 
	IF NEW.datum_zavrsetka < CURDATE() THEN
        DELETE FROM popusti WHERE id = NEW.id;
    END IF;
END; //
DELIMITER ;

-- Okidač koji sprječava unos negativne cijene isporuke (Bruno)
DELIMITER //
CREATE TRIGGER bi_nacini_isporuke
BEFORE INSERT ON nacini_isporuke
FOR EACH ROW
BEGIN
	IF NEW.cijena < 0 THEN
		SIGNAL SQLSTATE "45101" SET MESSAGE_TEXT= "Cijena isporuke ne može biti negativna";
	END IF;
END//
DELIMITER ;

/*
-- provjera okidača
INSERT INTO nacini_isporuke (naziv,opis,cijena,trajanje) VALUES
("Express dostava","Dostava u roku 3 sata",-20,0);
*/





--  Pogled: Pregled proizvoda sa statusom popusta (Fran)

CREATE VIEW proizvodi_sa_statusom_popusta AS
SELECT 
    p.id AS proizvod_id,
    p.naziv AS proizvod_naziv,
    p.cijena AS originalna_cijena,
    COALESCE((p.cijena - (p.cijena * pop.postotak_popusta / 100)), p.cijena) AS cijena_sa_popustom,
    pop.postotak_popusta,
    CASE 
        WHEN CURRENT_TIMESTAMP BETWEEN pop.datum_pocetka AND pop.datum_zavrsetka THEN 'Aktivan'
        ELSE 'Neaktivan'
    END AS status_popusta
FROM proizvodi p
LEFT JOIN popusti pop ON p.id = pop.proizvod_id
ORDER BY status_popusta DESC, p.naziv;

--  Pogled: Pregled narudzbi sa statusom isporuke (Fran)

CREATE VIEW narudzbe_sa_statusom_isporuke AS
SELECT 
    n.id AS narudzba_id,
    n.datum_narudzbe,
    n.status_narudzbe,
    i.status_isporuke,
    i.datum_isporuke AS datum_statusa
FROM narudzbe n
LEFT JOIN pracenje_isporuka i ON n.id = i.narudzba_id
ORDER BY n.datum_narudzbe DESC, i.datum_isporuke DESC;

--  Pogled: Pregled proizvoda po kategoriji s prosjecnim ocjenama (Fran)

CREATE VIEW proizvodi_po_kategorijama_sa_ocjenama AS
SELECT 
    k.naziv AS kategorija,
    p.id AS proizvod_id,
    p.naziv AS proizvod_naziv,
    AVG(r.ocjena) AS prosjecna_ocjena,
    COUNT(r.id) AS broj_recenzija
FROM proizvodi p
JOIN kategorije_proizvoda k ON p.kategorija_id = k.id
LEFT JOIN recenzije_proizvoda r ON p.id = r.proizvod_id
GROUP BY k.naziv, p.id, p.naziv
ORDER BY k.naziv, prosjecna_ocjena DESC;

-- Okidač: Automatsko postavljanje statusa narudzbe (Fran)

DELIMITER //
CREATE TRIGGER postavi_status_narudzbe
BEFORE INSERT ON narudzbe
FOR EACH ROW
BEGIN
    IF NEW.status_narudzbe IS NULL THEN
        SET NEW.status_narudzbe = 'u obradi';
    END IF;
END//
DELIMITER ;


-- Funkcija: Povrata proizvoda (Fran)

DELIMITER //

CREATE FUNCTION DohvatiPovrateZaNarudzbu(narudzbaId INT)
RETURNS TEXT
DETERMINISTIC
BEGIN
    DECLARE povrati_info TEXT;

    SELECT GROUP_CONCAT(
               CONCAT(DATE_FORMAT(datum_povrata, '%Y-%m-%d'), ': ', status_povrata)
               SEPARATOR '\n'
           )
    INTO povrati_info
    FROM povrati_proizvoda
    WHERE narudzba_id = narudzbaId;

    RETURN IFNULL(povrati_info, 'Nema povrata za odabranu narudžbu.');
END //

DELIMITER ;

-- Procedura za unos povrata proizvoda (fran)
DELIMITER //
CREATE PROCEDURE DodajPovratProizvoda (
    IN p_id_narudzbe INT,
    IN p_datum_povrata DATE,
    IN p_razlog_povrata TEXT,
    IN p_status_povrata VARCHAR(50)
)
BEGIN
    INSERT INTO povrati_proizvoda (id_narudzbe, datum_povrata, razlog_povrata, status_povrata)
    VALUES (p_id_narudzbe, p_datum_povrata, p_razlog_povrata, p_status_povrata);
END //
DELIMITER ;

-- Procedura za praćenje isporuke (fran)
DELIMITER //
CREATE PROCEDURE DodajStanjeIsporuke (
    IN p_id_narudzbe INT,
    IN p_stanje_narudzbe VARCHAR(50),
    IN p_datum_narudzbe DATE,
    IN p_nacin_isporuke INT
)
BEGIN
    DECLARE trajanje_dostave INT;
    DECLARE izracunati_datum DATE;
    SELECT trajanje_u_danima
    INTO trajanje_dostave
    FROM vrste_dostave
    WHERE id_vrste_dostave = p_nacin_isporuke;
    SET izracunati_datum = DATE_ADD(p_datum_narudzbe, INTERVAL trajanje_dostave DAY);
    INSERT INTO stanje_isporuke (id_narudzbe, stanje_narudzbe, datum_azuriranja, predvideni_datum_isporuke)
    VALUES (p_id_narudzbe, p_stanje_narudzbe, NOW(), izracunati_datum);
END //
DELIMITER ;

-- Procedura za korisnike (fran)
DELIMITER //
CREATE PROCEDURE DodajKorisnika (
    IN p_ime VARCHAR(50),
    IN p_prezime VARCHAR(50),
    IN p_email VARCHAR(100),
    IN p_telefon VARCHAR(20)
)
BEGIN
    INSERT INTO korisnici (ime, prezime, email, telefon)
    VALUES (p_ime, p_prezime, p_email, p_telefon);
END //

CREATE PROCEDURE AzurirajKorisnika (
    IN p_id_korisnika INT,
    IN p_ime VARCHAR(50),
    IN p_prezime VARCHAR(50),
    IN p_email VARCHAR(100),
    IN p_telefon VARCHAR(20)
)
BEGIN
    UPDATE korisnici
    SET ime = p_ime, prezime = p_prezime, email = p_email, telefon = p_telefon
    WHERE id_korisnika = p_id_korisnika;
END //

CREATE PROCEDURE ObrisiKorisnika (
    IN p_id_korisnika INT
)
BEGIN
    DELETE FROM korisnici
    WHERE id_korisnika = p_id_korisnika;
END //
DELIMITER ;

-- Josip: Upit popusta za svaku narudžbu
SELECT 
    n.id AS narudzba_id,
    r.id AS racun_id,
    k.kod AS kupon_kod,
    k.postotak_popusta AS popust_u_postotcima,
    r.iznos AS iznos_racuna,
    (r.iznos * (k.postotak_popusta / 100)) AS ukupni_popust,
    (r.iznos - (r.iznos * (k.postotak_popusta / 100))) AS iznos_sa_popustom
FROM racuni r
LEFT JOIN narudzbe n ON r.narudzba_id = n.id
LEFT JOIN kuponi k ON n.kupon_id = k.id
ORDER BY n.id;

-- Josip: Upit uplata po narudžbama
SELECT 
    n.id AS narudzba_id,
    COUNT(p.id) AS broj_placanja,
    SUM(p.iznos) AS ukupno_placeno,
    r.iznos AS iznos_racuna,
    (r.iznos - SUM(p.iznos)) AS preostalo_za_placanje
FROM narudzbe n
LEFT JOIN racuni r ON n.id = r.narudzba_id
LEFT JOIN placanja p ON n.id = p.narudzba_id
GROUP BY n.id, r.iznos
ORDER BY n.id;


-- Josip: Pogled za pregled računa s kuponima
CREATE VIEW racuni_sa_kuponima AS
SELECT 
    r.id AS racun_id,
    r.iznos AS ukupni_iznos_racuna,
    k.kod AS kupon_kod,
    k.postotak_popusta,
    (r.iznos - (r.iznos * k.postotak_popusta / 100)) AS iznos_sa_popustom
FROM racuni r
LEFT JOIN narudzbe n ON r.narudzba_id = n.id
LEFT JOIN kuponi k ON n.kupon_id = k.id
ORDER BY r.datum_izdavanja DESC;

-- Josip: Pogled za plaćanja po načinu plaćanja
CREATE VIEW placanja_po_nacinu AS
SELECT 
    p.nacin_placanja,
    COUNT(p.id) AS broj_placanja,
    SUM(p.iznos) AS ukupni_iznos
FROM placanja p
GROUP BY p.nacin_placanja
ORDER BY ukupni_iznos DESC;

-- Josip: Funkcija za preostalo iskorištenje kupona
DELIMITER //
CREATE FUNCTION preostalo_iskoristenje_kupona(kupon_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE preostalo INT;
    SELECT (k.max_iskoristenja - COUNT(n.id))
    INTO preostalo
    FROM kuponi k
    LEFT JOIN narudzbe n ON k.id = n.kupon_id
    WHERE k.id = kupon_id;
    RETURN IFNULL(preostalo, k.max_iskoristenja);
END //
DELIMITER ;

-- Josip: Funkcija za ukupni prihod po korisniku
DELIMITER //
CREATE FUNCTION ukupni_prihod_po_korisniku(korisnik_id INT)
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE ukupno DECIMAL(10, 2);
    SELECT SUM(iznos)
    INTO ukupno
    FROM racuni
    WHERE korisnik_id = korisnik_id;
    RETURN IFNULL(ukupno, 0.00);
END //
DELIMITER ;

-- Josip: Okidač za ograničenje maksimalnog iskorištenja kupona
DELIMITER //
CREATE TRIGGER ograničenje_iskorištenja_kupona
BEFORE INSERT ON narudzbe
FOR EACH ROW
BEGIN
    DECLARE iskorištenja INT;
    SELECT COUNT(id)
    INTO iskorištenja
    FROM narudzbe
    WHERE kupon_id = NEW.kupon_id;
    IF iskorištenja >= (SELECT max_iskoristenja FROM kuponi WHERE id = NEW.kupon_id) THEN
        SIGNAL SQLSTATE '45200' SET MESSAGE_TEXT = 'Kupon je dosegao maksimalan broj iskorištenja!';
    END IF;
END //
DELIMITER ;

-- Josip: Okidač za automatsko postavljanje datuma izdavanja računa
DELIMITER //
CREATE TRIGGER postavi_datum_izdavanja
BEFORE INSERT ON racuni
FOR EACH ROW
BEGIN
    IF NEW.datum_izdavanja IS NULL THEN
        SET NEW.datum_izdavanja = CURDATE();
    END IF;
END //
DELIMITER ;

-- Josip: Procedura za dodavanje plaćanja
DELIMITER //
CREATE PROCEDURE dodaj_placanje (
    IN p_narudzba_id INT,
    IN p_nacin_placanja ENUM('kartica', 'pouzeće'),
    IN p_iznos DECIMAL(10, 2),
    IN p_datum_placanja DATE
)
BEGIN
    INSERT INTO placanja (narudzba_id, nacin_placanja, iznos, datum_placanja)
    VALUES (p_narudzba_id, p_nacin_placanja, p_iznos, p_datum_placanja);
END //
DELIMITER ;

-- Josip: Procedura za dodavanje kupona
DELIMITER //
CREATE PROCEDURE dodaj_kupon (
    IN p_kod VARCHAR(50),
    IN p_postotak_popusta DECIMAL(5, 2),
    IN p_datum_pocetka DATE,
    IN p_datum_zavrsetka DATE,
    IN p_max_iskoristenja INT
)
BEGIN
    INSERT INTO kuponi (kod, postotak_popusta, datum_pocetka, datum_zavrsetka, max_iskoristenja)
    VALUES (p_kod, p_postotak_popusta, p_datum_pocetka, p_datum_zavrsetka, p_max_iskoristenja);
END //
DELIMITER ;


