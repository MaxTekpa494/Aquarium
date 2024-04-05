--
-- Drop tables
--

DROP TABLE IF EXISTS espece CASCADE;
DROP TABLE IF EXISTS animal CASCADE;
DROP TABLE IF EXISTS nourriture CASCADE;
DROP TABLE IF EXISTS employe CASCADE;
DROP TABLE IF EXISTS secteur CASCADE;
DROP TABLE IF EXISTS bassin CASCADE;
DROP TABLE IF EXISTS activite CASCADE;
DROP TABLE IF EXISTS mange CASCADE;
DROP TABLE IF EXISTS vivent CASCADE;
DROP TABLE IF EXISTS coabitent CASCADE;
DROP TABLE IF EXISTS occupe CASCADE;
DROP TABLE IF EXISTS affecte CASCADE;
DROP TABLE IF EXISTS mot_de_passe CASCADE;



--
-- Create table espece
--

CREATE TABLE espece(
    idespece serial primary key,
    nom_espece varchar(30),
    exp_vie int,
    reg_alimentaire text,
    niv_menace int CHECK(niv_menace BETWEEN 0 and 10)
);

--
-- Create table animal
--

CREATE TABLE animal(
    idanimal int primary key,
    nom varchar(25),
    sexe varchar(10),
    signeDis text,
    lieuNais varchar(25) not null default 'extérieur',
    dateA date not null,
    dateD date,
    situation varchar(15),
    idespece serial,
    FOREIGN KEY (idespece) REFERENCES espece(idespece)
    ON DELETE SET NULL ON UPDATE CASCADE
);


--
-- Create table nourriture
--

CREATE TABLE nourriture(
    idnourriture int primary key,
    nom varchar(25),
    qstock int
);


--
-- Create table employe
--

CREATE TABLE employe(
    numSS varchar(25) primary key,
    nom varchar(25),
    prenom varchar(25),
    adresse varchar(100),
    dateNais date,
    gestionnaire boolean default false
);


--
-- Create table secteur
--

CREATE TABLE secteur(
    idSect serial primary key,
    nomSect text,
    localisation varchar(10)
);


--
-- Create table bassin
--

CREATE TABLE bassin(
    numBassin int primary key,
    capaciteMax int,
    volEau int,
    etat varchar(10),
    numSS varchar(25) default null,
    idSect serial,
    FOREIGN KEY (numSS) REFERENCES employe(numSS)
    ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (idSect) REFERENCES secteur(idSect)
    ON DELETE SET NULL ON UPDATE CASCADE
);


--
-- Create table activite
--

CREATE TABLE activite(
    idActivite serial primary key,
    nomAc varchar(30),
    jour varchar(15),
    heure varchar(15),
    situation varchar(20),
    numBassin int,
    FOREIGN KEY (numBassin) REFERENCES bassin(numBassin)
    ON DELETE CASCADE ON UPDATE CASCADE
);


--
-- Create table mange
--

CREATE TABLE mange(
    idespece serial,
    idnourriture int, 
    quantité int, 
    primary key(idespece,idnourriture),
    FOREIGN KEY (idespece) REFERENCES espece(idespece)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (idnourriture) REFERENCES nourriture(idnourriture)
    ON DELETE CASCADE ON UPDATE CASCADE
);


--
-- Create table coabitation
--

CREATE TABLE coabitent(
    idespece serial,
    idespece2 serial,
    primary key(idespece,idespece2),
    FOREIGN KEY (idespece2) REFERENCES espece(idespece)
    ON DELETE CASCADE ON UPDATE CASCADE
);


--
-- Create table vivent
--

CREATE TABLE vivent(
    idespece serial,
    numBassin int,
    primary key(idespece,numBassin),
    FOREIGN KEY (idespece) REFERENCES espece(idespece)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (numBassin) REFERENCES bassin(numBassin)
    ON DELETE CASCADE ON UPDATE CASCADE
);


--
-- Create table occupe
--

CREATE TABLE occupe(
    numSS varchar(25),
    idactivite int,
    durée decimal(3,2),
    primary key(numSS,idactivite),
    FOREIGN KEY (numSS) REFERENCES employe(numSS)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (idactivite) REFERENCES activite(idactivite)
    ON DELETE CASCADE ON UPDATE CASCADE
    );

--
-- Create table affecte
--

CREATE TABLE affecte(
    idSect serial,
    numSS varchar(25),
    primary key(idSect,numSS),
    FOREIGN KEY (idSect) REFERENCES secteur(idSect)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (numSS) REFERENCES employe(numSS)
    ON DELETE CASCADE ON UPDATE CASCADE
);


--
-- Create table mot_de_passe
--

CREATE TABLE mot_de_passe(
    numSS varchar(25) primary key,
    mdt varchar(200),
    FOREIGN KEY (numSS) REFERENCES employe(numSS)
    ON DELETE CASCADE ON UPDATE CASCADE
);





--
-- Data for Name: espece
--

INSERT INTO espece (nom_espece, exp_vie, reg_alimentaire, niv_menace) VALUES ('coraux', 200, 'alguivore', 8);
INSERT INTO espece (nom_espece, exp_vie, reg_alimentaire, niv_menace) VALUES ('crustacé', 70, 'planctonivore', 3);
INSERT INTO espece (nom_espece, exp_vie, niv_menace) VALUES ('coquillage', 40, 5);
INSERT INTO espece (nom_espece, exp_vie, reg_alimentaire, niv_menace) VALUES ('etoiles de mer', 5, 'carnivores', 2);
INSERT INTO espece (nom_espece, exp_vie, reg_alimentaire, niv_menace) VALUES ('oursins', 4, 'alguivore', 6);
INSERT INTO espece (nom_espece, exp_vie, reg_alimentaire, niv_menace) VALUES ('requin gris', 73, 'piscivore', 9);
INSERT INTO espece (nom_espece, exp_vie, reg_alimentaire, niv_menace) VALUES ('meduise', 4, 'piscivore', 3);
INSERT INTO espece (nom_espece, exp_vie, reg_alimentaire, niv_menace) VALUES ('scalaire', 5, ' omnivore', 7);
INSERT INTO espece (nom_espece, exp_vie, reg_alimentaire, niv_menace) VALUES ('xiphophorus', 5, 'omnivore', 4);

--
-- Data for Name: animal
--

INSERT INTO animal (idanimal, nom, sexe, signeDis, lieuNais, dateA, dateD, situation, idespece) VALUES (19,'crevette','femelle','Couleur rose','née à l"aquaruim','2018-10-06','2020-07-01','mort',2);
INSERT INTO animal (idanimal, nom, sexe, signeDis, dateA, dateD, situation, idespece) VALUES (23,'nasus','male','queue noire','2015-03-08','2016-07-01','transféré',6);
INSERT INTO animal (idanimal, nom, sexe, lieuNais, dateA, idespece) VALUES (25,'mespilia','femelle','née à l"aquaruim','2016-06-16',5);
INSERT INTO animal (idanimal, nom, sexe, dateA, dateD, situation, idespece) VALUES (27,'grobulus','male','2012-01-04', '2014-09-10','transféré',5);
INSERT INTO animal (idanimal, nom, sexe, signeDis, dateA, dateD, situation, idespece) VALUES (29,'ophiures','femelle','long bras','2018-11-06','2019-05-28','mort',4);
INSERT INTO animal (idanimal, nom, sexe, signeDis, dateA, dateD, situation, idespece) VALUES (31,'fromia','male','long bras','2010-01-06','2015-11-17','transféré',4);
INSERT INTO animal (idanimal, nom, sexe, dateA, dateD, situation, idespece) VALUES (33,'coque','male','2014-03-19','2016-08-25','transféré',3);
INSERT INTO animal (idanimal, nom, sexe, signeDis, lieuNais, dateA, dateD, situation, idespece) VALUES (34,'Anodonta','femelle','trait','née à l"aquaruim','2009-02-22','2011-09-26','mort',3);
INSERT INTO animal (idanimal, nom, sexe, signeDis, lieuNais, dateA, idespece) VALUES (35,'cassiopée','femelle','tentacule en air','née à l"aquaruim','2012-06-02',7);
INSERT INTO animal (idanimal, nom, sexe, signeDis, dateA, dateD, situation, idespece) VALUES (37,'echizen','male','tentacule jaune','2021-12-03','2022-04-11','transféré',7);
INSERT INTO animal (idanimal, nom, sexe, signeDis, lieuNais, dateA, dateD, situation, idespece) VALUES (39,'crabe','femelle','Couleur rouge','née à l"aquaruim','2012-04-16','2013-09-30','mort',2);
INSERT INTO animal (idanimal, nom, sexe, dateA, dateD, situation, idespece) VALUES (41,'carch','male','2021-05-19','2022-07-11','transféré',6);
INSERT INTO animal (idanimal, nom, sexe, lieuNais, dateA, dateD, situation, idespece) VALUES (43,'porite','male','née à l"aquaruim','2010-11-26','2015-07-01','mort',1);
INSERT INTO animal (idanimal, nom, sexe, dateA, dateD, situation, idespece) VALUES (45,'gorgones','femelle','2010-11-26','2015-07-01','transféré',1);
INSERT INTO animal (idanimal, nom, sexe, lieuNais, dateA, idespece) VALUES (47,'scale','femelle','née à l"aquaruim','2022-11-10', 8);
INSERT INTO animal (idanimal, nom, sexe, dateA, idespece) VALUES (48,'xiphos','male','2022-10-01', 9);




--
-- Data for Name: nourriture
--

INSERT INTO nourriture (idnourriture, nom, qstock) VALUES (300,'algues', 500); 
INSERT INTO nourriture (idnourriture, nom, qstock) VALUES (252,'larves', 1200); 
INSERT INTO nourriture (idnourriture, nom, qstock) VALUES (148,'particules', 300); 
INSERT INTO nourriture (idnourriture, nom, qstock) VALUES (476,'coquillages', 757); 
INSERT INTO nourriture (idnourriture, nom, qstock) VALUES (354,'crustacé', 689); 
INSERT INTO nourriture (idnourriture, nom, qstock) VALUES (531,'poisson', 356);


--
-- Data for Name: employe
--

INSERT INTO employe (numSS, nom, prenom, adresse, dateNais, gestionnaire) VALUES (56465,'Durand','Kevin','7 rue des Fleurs 37000 Tours','1977-07-18',true);
INSERT INTO employe (numSS, nom, prenom, adresse, dateNais, gestionnaire) VALUES (46233,'Stephn','Curry','27 rue du Ballon 93160 Noisy','1985-05-24',false);
INSERT INTO employe (numSS, nom, prenom, adresse, dateNais, gestionnaire) VALUES (79432,'Messi','Lionel','14 avenue du Monde 69231 Valence','1986-06-24',true);
INSERT INTO employe (numSS, nom, prenom, adresse, dateNais, gestionnaire) VALUES (86413,'Mane','Sadio','10 du Senegal 57463 Metz','1992-11-01',false);
INSERT INTO employe (numSS, nom, prenom, adresse, dateNais, gestionnaire) VALUES (52256,'Salah','Mohammed','23 Boulevardes des Pharaons 93000 Bobigny','1977-07-18',false);
INSERT INTO employe (numSS, nom, prenom, adresse, dateNais, gestionnaire) VALUES (19634,'Lottin','Killian','32 rue de Vitesse 93200 Bondy','1998-11-28',true);
INSERT INTO employe (numSS, nom, prenom, adresse, dateNais, gestionnaire) VALUES (28324,'Lorris','Hugo','06 rue des Spurs 30140 Anduze','1987-03-15',false);
INSERT INTO employe (numSS, nom, prenom, adresse, dateNais, gestionnaire) VALUES (37614,'Dupont','Loik','20 rue de lOr 75016 Paris','1995-11-17',true);
INSERT INTO employe (numSS, nom, prenom, adresse, dateNais, gestionnaire) VALUES (34524,'Tran','Thien-loc','06 rue Tekpa 30140 Anduze','1979-12-07',false);


--
-- Data for Name: secteur
--

INSERT INTO secteur (idSect, nomSect, localisation) VALUES (1, 'Poisson tropicaux', 'Nord-Ouest');
INSERT INTO secteur (idSect, nomSect, localisation) VALUES (2, 'Archipel', 'Ouest');
--INSERT INTO secteur (idSect, nomSect, localisation) VALUES (3, 'Lumineux', 'Sud');
INSERT INTO secteur (idSect, nomSect, localisation) VALUES (3, 'oméga-3', 'Ouest');



--
-- Data for Name: bassin
--

INSERT INTO bassin (numBassin, capaciteMax, volEau, etat, numSS, idSect) VALUES (4, 302, 408, 'Propre', 56465, 1);
INSERT INTO bassin (numBassin, capaciteMax, volEau, etat, numSS, idSect) VALUES (5, 100, 350, 'Sale', 52256, 3);
INSERT INTO bassin (numBassin, capaciteMax, volEau, etat, numSS, idSect) VALUES (3, 302, 408, 'Propre', 56465, 2);
INSERT INTO bassin (numBassin, capaciteMax, volEau, etat, numSS, idSect) VALUES (2, 612, 710, 'Propre', 52256, 3);
INSERT INTO bassin (numBassin, capaciteMax, volEau, etat, numSS, idSect) VALUES (1, 65, 241, 'Propre', 52256, 1);
INSERT INTO bassin (numBassin, capaciteMax, volEau, etat, numSS, idSect) VALUES (6, 40, 700, 'Sale', 34524, 2);



--
-- Data for Name: activite
--

INSERT INTO activite (nomAc, jour, heure, situation, numBassin) VALUES ('bilan vétérinaire', 'Samedi', '11h15 à 11h45', 'Ouverte', 1);
INSERT INTO activite (nomAc, heure, situation, numBassin) VALUES ('inspection de la qualité deau',  '07h à 07h30', 'Fermée', 1);
INSERT INTO activite (nomAc, jour, heure, situation, numBassin) VALUES ('nourrissage', 'Lundi', '10h à 10h30', 'Ouverte', 1);
INSERT INTO activite (nomAc, heure, situation, numBassin) VALUES ('nourrissage', '19h à 19h30', 'Ouverte', 1);
INSERT INTO activite (nomAc, heure, situation, numBassin) VALUES ('inspection de la qualité deau', '8h à 8h15', 'Fermée', 5);
INSERT INTO activite (nomAc, jour, heure, situation, numBassin) VALUES ('bilan vétérinaire', 'Mercrédi', '7h à 7h45', 'Fermée', 5);
INSERT INTO activite (nomAc, heure, situation, numBassin) VALUES ('nourrissage',  '12h à 12h30', 'Ouverte', 5);
INSERT INTO activite (nomAc, heure, situation, numBassin) VALUES ('nourrissage',  '12h à 12h30', 'Ouverte', 2);
INSERT INTO activite (nomAc, heure, situation, numBassin) VALUES ('nourrissage',  '18h30h à 19h10', 'Ouverte', 2);
INSERT INTO activite (nomAc, jour, heure, situation, numBassin) VALUES ('bilan vétérinaire', 'Jeudi', '11h15 à 11h45', 'Ouverte', 2);
INSERT INTO activite (nomAc, heure, situation, numBassin) VALUES ('inspection de la qualité deau',  '07h à 07h30', 'Fermée', 2);
INSERT INTO activite (nomAc, heure, situation, numBassin) VALUES ('nourrissage',  '12h à 12h30', 'Ouverte', 4);
INSERT INTO activite (nomAc, heure, situation, numBassin) VALUES ('nourrissage',  '18h30h à 19h10', 'Ouverte', 4);
INSERT INTO activite (nomAc, heure, situation, numBassin) VALUES ('inspection de la qualité deau',  '07h à 07h30', 'Fermée', 4);
INSERT INTO activite (nomAc, heure, situation, numBassin) VALUES ('nourrissage',  '18h30h à 19h10', 'Ouverte', 6);
INSERT INTO activite (nomAc, jour, heure, situation, numBassin) VALUES ('inspection de la qualité deau', 'Mardi', '07h à 07h45', 'Fermée', 6);


--
-- Data for Name: mange
--
INSERT INTO mange (idespece, idnourriture, quantité) VALUES (1, 300, 20);
INSERT INTO mange (idespece, idnourriture, quantité) VALUES (5, 300, 260);
INSERT INTO mange (idespece, idnourriture, quantité) VALUES (2, 252, 30);
INSERT INTO mange (idespece, idnourriture, quantité) VALUES (3, 148, 5);
INSERT INTO mange (idespece, idnourriture, quantité) VALUES (4, 476, 125);
INSERT INTO mange (idespece, idnourriture, quantité) VALUES (6, 354, 150);
INSERT INTO mange (idespece, idnourriture, quantité) VALUES (7, 531, 102);


--
-- Data for Name: coabitent
--


INSERT INTO coabitent (idespece, idespece2) VALUES (1, 5);
INSERT INTO coabitent (idespece, idespece2) VALUES (6, 7);
INSERT INTO coabitent (idespece, idespece2) VALUES (8, 9);


--
-- Data for Name: vivent
--

INSERT INTO vivent (idespece, numBassin) VALUES (8, 4);
INSERT INTO vivent (idespece, numBassin) VALUES (9, 4);
INSERT INTO vivent (idespece, numBassin) VALUES (6, 3);
INSERT INTO vivent (idespece, numBassin) VALUES (7, 3);
INSERT INTO vivent (idespece, numBassin) VALUES (1, 1);
INSERT INTO vivent (idespece, numBassin) VALUES (5, 1);
INSERT INTO vivent (idespece, numBassin) VALUES (2, 6);
INSERT INTO vivent (idespece, numBassin) VALUES (3, 5);

--
-- Data for Name: occupe
--

INSERT INTO occupe (numSS, idactivite, durée) VALUES (56465, 13, 0.40);
INSERT INTO occupe (numSS, idactivite, durée) VALUES (56465, 16, 1.45);
INSERT INTO occupe (numSS, idactivite, durée) VALUES (46233, 16, 1.45);
INSERT INTO occupe (numSS, idactivite, durée) VALUES (46233, 1, 1.30);
INSERT INTO occupe (numSS, idactivite, durée) VALUES (79432, 1, 1.30);
INSERT INTO occupe (numSS, idactivite, durée) VALUES (86413, 5, 0.15);
INSERT INTO occupe (numSS, idactivite, durée) VALUES (86413, 7, 1.30);
INSERT INTO occupe (numSS, idactivite, durée) VALUES (86413, 14, 1.30);
INSERT INTO occupe (numSS, idactivite, durée) VALUES (52256, 4, 1.30);
INSERT INTO occupe (numSS, idactivite, durée) VALUES (52256, 16, 1.45);
INSERT INTO occupe (numSS, idactivite, durée) VALUES (52256, 6, 0.45);
INSERT INTO occupe (numSS, idactivite, durée) VALUES (19634, 8, 0.30);
INSERT INTO occupe (numSS, idactivite, durée) VALUES (19634, 9, 0.40);
INSERT INTO occupe (numSS, idactivite, durée) VALUES (19634, 11, 0.30);
INSERT INTO occupe (numSS, idactivite, durée) VALUES (28324, 15, 0.40);
INSERT INTO occupe (numSS, idactivite, durée) VALUES (28324, 12, 0.30);
INSERT INTO occupe (numSS, idactivite, durée) VALUES (28324, 3, 0.30);
INSERT INTO occupe (numSS, idactivite, durée) VALUES (28324, 10, 0.30);
INSERT INTO occupe (numSS, idactivite, durée) VALUES (37614, 2, 0.30);
INSERT INTO occupe (numSS, idactivite, durée) VALUES (37614, 3, 0.30);
INSERT INTO occupe (numSS, idactivite, durée) VALUES (37614, 4, 0.15);
INSERT INTO occupe (numSS, idactivite, durée) VALUES (34524, 12, 0.30);
INSERT INTO occupe (numSS, idactivite, durée) VALUES (34524, 16, 0.45);
INSERT INTO occupe (numSS, idactivite, durée) VALUES (34524, 15, 0.40);
INSERT INTO occupe (numSS, idactivite, durée) VALUES (34524, 3, 0.30);



---
-- Data for Name: affecte
---

INSERT INTO affecte (idSect, numSS) VALUES (1, 56465);
INSERT INTO affecte (idSect, numSS) VALUES (2, 56465);
INSERT INTO affecte (idSect, numSS) VALUES (3, 56465);
INSERT INTO affecte (idSect, numSS) VALUES (1, 46233);
INSERT INTO affecte (idSect, numSS) VALUES (2, 46233);
INSERT INTO affecte (idSect, numSS) VALUES (3, 46233);
INSERT INTO affecte (idSect, numSS) VALUES (1, 79432);
INSERT INTO affecte (idSect, numSS) VALUES (2, 79432);
INSERT INTO affecte (idSect, numSS) VALUES (3, 79432);
INSERT INTO affecte (idSect, numSS) VALUES (1, 86413);
INSERT INTO affecte (idSect, numSS) VALUES (2, 86413);
INSERT INTO affecte (idSect, numSS) VALUES (3, 86413);
INSERT INTO affecte (idSect, numSS) VALUES (1, 52256);
INSERT INTO affecte (idSect, numSS) VALUES (2, 52256);
INSERT INTO affecte (idSect, numSS) VALUES (3, 52256);
INSERT INTO affecte (idSect, numSS) VALUES (1, 19634);
INSERT INTO affecte (idSect, numSS) VALUES (2, 19634);
INSERT INTO affecte (idSect, numSS) VALUES (3, 19634);
INSERT INTO affecte (idSect, numSS) VALUES (1, 28324);
INSERT INTO affecte (idSect, numSS) VALUES (2, 28324);
INSERT INTO affecte (idSect, numSS) VALUES (3, 28324);
INSERT INTO affecte (idSect, numSS) VALUES (1, 37614);
INSERT INTO affecte (idSect, numSS) VALUES (2, 37614);
INSERT INTO affecte (idSect, numSS) VALUES (3, 37614);
INSERT INTO affecte (idSect, numSS) VALUES (1, 34524);
INSERT INTO affecte (idSect, numSS) VALUES (2, 34524);
INSERT INTO affecte (idSect, numSS) VALUES (3, 34524);



--
-- Data for Name: mot_de_passe
--

INSERT INTO mot_de_passe VALUES (56465, '$2b$12$VdzMSSbzdnf205U/7WUA8O90IHm3ikiUDyANup5lqxawD1/OfgKg6');
INSERT INTO mot_de_passe VALUES (46233, '$2b$12$GKcV2U2MxjPT9/4/sd/2OuTK.DXUPL3gCKkfjcRNez.ZqTMA9rS0G');
INSERT INTO mot_de_passe VALUES (79432, '$2b$12$bKiTXWWeR6L7NDh4LQEo0eeP59B.wi1HLWe5SObCzXTpi4N/bAcha');
INSERT INTO mot_de_passe VALUES (86413, '$2b$12$pPHaReOYUzuh.S7WH30izeCZoLhNCYmuaLgs5vqzRxuhhKgFnL5hS');
INSERT INTO mot_de_passe VALUES (52256, '$2b$12$GP6NKvFiLendmMoIwQmZAOhGGV05s1HWmbx6nkgrmJ/j2jVVpRL9W');
INSERT INTO mot_de_passe VALUES (19634, '$2b$12$rItfP7/hAke4WZqb26hlveFczxYAVDgSiyiZexqNaz6zO5QtxW/TG');
INSERT INTO mot_de_passe VALUES (28324, '$2b$12$JVsKzLj41.bBIxL2XlMPLunzY.PxvUAUrtFU5TvRbpEBE3HMR3dLS');
INSERT INTO mot_de_passe VALUES (37614, '$2b$12$O/Mds5Nj1gt3VX0lmDVD8u1GcRSwq/x2ACQSJx6uT4II1Rw1NS5nC');
INSERT INTO mot_de_passe VALUES (34524, '$2b$12$qLHWHlknamOiIjE21C8T7O6edNRyMbCTDHOtqOzRYsPhZ7x6FpFE6');