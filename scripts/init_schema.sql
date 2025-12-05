--schema en etoile pour certificationfinder
--on cree les tables de dimensions d'abord, puis la table de faits
--comme dans un bon anime, faut respecter l'ordre des arcs narratifs

--extension pour generer des uuid, parce que les id auto-increment c'est so 2010
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

--table dimension profil, nos etudiants anonymises
CREATE TABLE IF NOT EXISTS profil (
    id VARCHAR(36) PRIMARY KEY DEFAULT uuid_generate_v4()::text,
    nom VARCHAR(30),
    prenom VARCHAR(30),
    email VARCHAR(100),
    age INTEGER,
    titre_poste VARCHAR(50),
    entreprise_actuelle VARCHAR(50),
    annees_experience INTEGER,
    niveau_etudes VARCHAR(20),
    secteur_activite VARCHAR(50),
    ville VARCHAR(50),
    pays VARCHAR(30) DEFAULT 'France'
);

--table dimension certification, les infos detaillees sur chaque certif
CREATE TABLE IF NOT EXISTS certification_dimension (
    id VARCHAR(36) PRIMARY KEY DEFAULT uuid_generate_v4()::text,
    nom VARCHAR(150),
    code VARCHAR(20),
    description TEXT,
    niveau INTEGER,
    domaine VARCHAR(50),
    validite VARCHAR(30),
    cout DECIMAL(10,2)
);

--table dimension competence, ce que les gens savent faire
CREATE TABLE IF NOT EXISTS competence (
    id VARCHAR(36) PRIMARY KEY DEFAULT uuid_generate_v4()::text,
    nom VARCHAR(100),
    categorie VARCHAR(50),
    domaine VARCHAR(50),
    niveau_requis VARCHAR(20)
);

--table dimension organisme, ceux qui delivrent les certifications
CREATE TABLE IF NOT EXISTS organisme (
    id VARCHAR(36) PRIMARY KEY DEFAULT uuid_generate_v4()::text,
    nom VARCHAR(100),
    pays VARCHAR(30) DEFAULT 'France',
    site_web VARCHAR(255),
    type_organisme VARCHAR(50)
);

--table de faits certification, le coeur du schema en etoile
--c'est ici que tout se connecte, comme le nexus dans une bonne histoire de sf
CREATE TABLE IF NOT EXISTS certification (
    id VARCHAR(36) PRIMARY KEY DEFAULT uuid_generate_v4()::text,
    profil_id VARCHAR(36) REFERENCES profil(id) ON DELETE CASCADE,
    certification_id VARCHAR(36) REFERENCES certification_dimension(id) ON DELETE CASCADE,
    competence_id VARCHAR(36) REFERENCES competence(id) ON DELETE SET NULL,
    organisme_id VARCHAR(36) REFERENCES organisme(id) ON DELETE SET NULL,
    is_valid BOOLEAN DEFAULT true,
    obtention_date TIMESTAMP,
    score_adequation DECIMAL(5,2)
);

--index pour optimiser les requetes frequentes
--comme un bon raccourci dans un jeu video, ca fait gagner du temps
CREATE INDEX IF NOT EXISTS idx_certification_profil ON certification(profil_id);
CREATE INDEX IF NOT EXISTS idx_certification_certif ON certification(certification_id);
CREATE INDEX IF NOT EXISTS idx_certification_competence ON certification(competence_id);
CREATE INDEX IF NOT EXISTS idx_certification_organisme ON certification(organisme_id);
CREATE INDEX IF NOT EXISTS idx_profil_niveau_etudes ON profil(niveau_etudes);
CREATE INDEX IF NOT EXISTS idx_profil_secteur ON profil(secteur_activite);
CREATE INDEX IF NOT EXISTS idx_profil_ville ON profil(ville);
CREATE INDEX IF NOT EXISTS idx_certification_dimension_domaine ON certification_dimension(domaine);
CREATE INDEX IF NOT EXISTS idx_competence_domaine ON competence(domaine);

--un petit message pour confirmer que tout s'est bien passe
DO $$
BEGIN
    RAISE NOTICE 'Schema CertificationFinder initialise avec succes, let''s go!';
END $$;
