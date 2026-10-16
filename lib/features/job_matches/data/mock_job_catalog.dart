import 'models/job_model.dart';

class MockJobCatalog {
  MockJobCatalog._();

  static List<Job>? _cachedCatalog;

  static List<Job> get catalog {
    _cachedCatalog ??= _buildDeterministicCatalog();
    return _cachedCatalog!;
  }

  static List<Job> _buildDeterministicCatalog() {
    final List<Job> jobs = [];

    const jobProfiles = [
      (
        title: 'Heavy Truck Driver',
        skills: ['Heavy vehicle', 'GCC licence', 'Route planning'],
        reason:
            '6 years of heavy vehicle experience and a valid GCC commercial licence',
        desc:
            'Operate articulated 18-wheeler tractor trailers across inter-emirate and regional cargo corridors. Responsible for vehicle pre-trip inspections, securing containerized cargo, and electronic trip log adherence.',
        reqs: [
          'Valid GCC Heavy Vehicle Driving Licence',
          'Minimum 3 years Gulf commercial driving experience',
          'Basic English or Hindi communication',
          'Clean driving record without major violations',
        ],
        minSal: 2800,
        maxSal: 3600,
      ),
      (
        title: 'Industrial Electrician',
        skills: ['Three-phase wiring', 'Motor controls', 'Troubleshooting'],
        reason:
            'Extensive hands-on background in commercial power distribution and industrial controls',
        desc:
            'Execute preventive maintenance and corrective troubleshooting on three-phase motors, MCC panels, and automated conveyor lines in a high-throughput distribution terminal.',
        reqs: [
          'ITI or Vocational Diploma in Electrical Engineering',
          '4+ years of industrial or commercial electrical experience',
          'Ability to read single-line wiring schematics',
          'Knowledge of Gulf electrical safety standards',
        ],
        minSal: 3200,
        maxSal: 4200,
      ),
      (
        title: 'Structural TIG/MIG Welder',
        skills: ['6G welding', 'Blueprint reading', 'Pressure vessels'],
        reason:
            'Certified 6G pipeline welding skills matching GCC fabrication specifications',
        desc:
            'Perform high-precision TIG and MIG welding on structural steel assemblies and industrial pipe spools. Work alongside quality control inspectors to guarantee radiographically sound joints.',
        reqs: [
          'AWS or equivalent 6G welding certification',
          '3+ years experience in structural or shipyard welding',
          'Proficiency with grinding, beveling, and fit-up tools',
          'Commitment to strict PPE and hot-work safety',
        ],
        minSal: 3000,
        maxSal: 4000,
      ),
      (
        title: 'HVAC Maintenance Technician',
        skills: ['Chiller systems', 'Refrigerant recovery', 'Ductwork'],
        reason:
            'Specialized experience servicing district cooling chillers and commercial air handlers',
        desc:
            'Maintain central cooling plants, fan coil units, and split AC systems across residential towers. Conduct seasonal refrigerant leak testing and compressor overhauls.',
        reqs: [
          'Diploma in Refrigeration & Air Conditioning (RAC)',
          '3+ years working on central chiller plants',
          'Familiarity with R-410A and R-134a refrigerants',
          'Physical stamina for rooftop maintenance operations',
        ],
        minSal: 3100,
        maxSal: 4100,
      ),
      (
        title: 'Warehouse Forklift Operator',
        skills: ['Reach truck', 'Pallet stacking', 'Inventory counting'],
        reason:
            'Certified reach-truck operator with over 4 years in high-density logistics hubs',
        desc:
            'Safely operate electric counterbalance and high-reach forklifts up to 12-meter racking levels. Utilize handheld barcode scanners for real-time stock put-away and order picking.',
        reqs: [
          'Valid Forklift Operator Certificate / Third-party card',
          '2+ years warehouse operations experience',
          'Familiarity with WMS scanning systems',
          'Strict adherence to pedestrian safety protocols',
        ],
        minSal: 2400,
        maxSal: 3100,
      ),
      (
        title: 'Retail Store Associate',
        skills: ['Customer service', 'Cash handling', 'Stock merchandising'],
        reason:
            'Friendly customer interaction and 3 years experience in hypermarket retail environments',
        desc:
            'Assist international shoppers on the retail sales floor, process POS transactions accurately, manage department restocking, and maintain pristine visual merchandising displays.',
        reqs: [
          'High school diploma or equivalent',
          '2+ years retail or supermarket floor experience',
          'Good conversational English (Hindi/Arabic is a plus)',
          'Professional grooming and active listening skills',
        ],
        minSal: 2200,
        maxSal: 2900,
      ),
      (
        title: 'Plumber & Pipe Fitter',
        skills: ['PPR & PVC piping', 'Drainage layouts', 'Hydro testing'],
        reason:
            'Proven expertise in multi-story residential plumbing networks and high-pressure testing',
        desc:
            'Install, inspect, and repair high-pressure potable water lines, drainage risers, and sanitary fixtures according to local municipality plumbing codes.',
        reqs: [
          'ITI in Plumbing or Trade Apprenticeship',
          '3+ years of commercial building plumbing experience',
          'Expertise in solvent cement and butt-fusion welding',
          'Ability to interpret architectural plumbing drawings',
        ],
        minSal: 2600,
        maxSal: 3300,
      ),
      (
        title: 'Finishing Mason & Tile Layer',
        skills: ['Tile alignment', 'Plastering', 'Marble installation'],
        reason:
            'Precision craftsmanship in large-format porcelain and marble installation',
        desc:
            'Execute top-tier tile laying, screeding, wall plastering, and stone cladding across luxury residential and commercial developments with minimal grout variance.',
        reqs: [
          '4+ years professional masonry and tiling experience',
          'Proficiency with laser leveling tools and tile cutters',
          'Attention to aesthetic edge finishing and waterproofing',
          'Physical ability to handle heavy materials',
        ],
        minSal: 2500,
        maxSal: 3200,
      ),
      (
        title: 'Automotive & Diesel Mechanic',
        skills: ['Engine diagnostics', 'Brake overhaul', 'Hydraulics'],
        reason:
            'Comprehensive diagnostic skills across Japanese and European fleet vehicles',
        desc:
            'Diagnose electronic sensor errors, service automatic transmissions, and rebuild diesel fuel injection systems for commercial delivery vans and utility fleets.',
        reqs: [
          'Diploma in Automobile Engineering or ITI Diesel Mechanic',
          '4+ years workshop experience with fleet diagnostics',
          'Proficiency using OBD-II computer scanners',
          'Valid light vehicle driving licence',
        ],
        minSal: 3400,
        maxSal: 4500,
      ),
      (
        title: 'Scaffolding Erector & Inspector',
        skills: ['Cuplok scaffolding', 'Safety rigging', 'Load calculation'],
        reason:
            'CISRS or equivalent scaffolding certified with strict zero-incident track record',
        desc:
            'Erect, alter, and dismantle heavy-duty industrial Cuplok and tube-and-clamp scaffolding structures around high-rise exteriors and refinery tanks under safety supervision.',
        reqs: [
          'Certified Scaffolding Card (CITB / CISRS / equivalent)',
          '3+ years experience on high-elevation construction',
          'Working at Heights training certification',
          'Zero fear of heights and strong situational awareness',
        ],
        minSal: 2700,
        maxSal: 3500,
      ),
      (
        title: 'Facility Painter & Decorator',
        skills: ['Airless spraying', 'Surface prep', 'Epoxy coating'],
        reason:
            'Skilled in high-durability epoxy floor coating and exterior weather-resistant painting',
        desc:
            'Prepare architectural substrates by sandblasting and power washing before applying primer, interior decorative finishes, and high-build exterior weather-shield coats.',
        reqs: [
          '3+ years professional painting experience',
          'Hands-on experience with Wagner/Graco airless sprayers',
          'Knowledge of epoxy and polyurethane chemical safety',
          'Precise masking and clean edge detailing',
        ],
        minSal: 2300,
        maxSal: 3000,
      ),
      (
        title: 'Storekeeper & Inventory Specialist',
        skills: ['Stock auditing', 'ERP data entry', 'Goods receipt'],
        reason:
            'Strong organization skills and proven experience managing spare parts inventories',
        desc:
            'Receive inbound sea-freight shipments, verify packing lists against purchase orders, organize bin locations in climate-controlled stockrooms, and issue daily tool consumables.',
        reqs: [
          'Bachelor degree or Diploma in Commerce/Supply Chain',
          '3+ years storekeeping in construction or automotive sector',
          'Working knowledge of MS Excel or inventory ERP software',
          'Meticulous documentation discipline',
        ],
        minSal: 2900,
        maxSal: 3800,
      ),
      (
        title: 'Mobile Crane Operator',
        skills: ['Telescopic crane', 'Sling rigging', 'Load charts'],
        reason:
            '50-ton telescopic crane operator with valid GCC heavy machinery operating licence',
        desc:
            'Operate mobile hydraulic rough-terrain cranes on civil engineering project sites. Interpret crane load charts, inspect wire ropes, and communicate via hand signals with banksmen.',
        reqs: [
          'Valid Heavy Equipment Operator Licence for Mobile Cranes',
          '5+ years experience on Grove, Liebherr, or Tadano cranes',
          'Knowledge of outrigger stabilization on varied soil',
          'Third-party heavy equipment safety certification',
        ],
        minSal: 4200,
        maxSal: 5500,
      ),
      (
        title: 'Commercial Kitchen Assistant',
        skills: ['Food prep', 'HACCP hygiene', 'Equipment sanitization'],
        reason:
            'HACCP-certified kitchen worker with 3 years high-volume catering experience',
        desc:
            'Prepare ingredients for high-volume central production kitchens, execute vegetable cutting, support hot line chefs, and maintain strict temperature logs and sanitization standards.',
        reqs: [
          'Basic Food Hygiene / HACCP Level 2 Certification',
          '2+ years experience in hotel or airline catering kitchens',
          'Willingness to work rotating shift schedules',
          'Punctual and cooperative team mindset',
        ],
        minSal: 2100,
        maxSal: 2700,
      ),
    ];

    const countries = [
      (
        country: 'UAE',
        cities: ['Dubai', 'Abu Dhabi', 'Sharjah', 'Ajman'],
        employers: [
          'Logistics company, UAE',
          'Facility Management Services, UAE',
          'Construction & Contracting Group, UAE',
          'Aviation Support Services, UAE',
          'Retail Operations Ltd, UAE',
          'Infrastructure Engineering, UAE',
          'Maritime Logistics, UAE',
        ],
      ),
      (
        country: 'Saudi Arabia',
        cities: ['Riyadh', 'Jeddah', 'Dammam', 'Al Khobar'],
        employers: [
          'Industrial Engineering Services, Saudi Arabia',
          'Energy & Construction Partners, Saudi Arabia',
          'Supply Chain Solutions, Saudi Arabia',
          'Urban Infrastructure Group, Saudi Arabia',
          'Commercial Facilities Co, Saudi Arabia',
          'Heavy Transport Services, Saudi Arabia',
          'Electro-Mechanical Contractors, Saudi Arabia',
        ],
      ),
      (
        country: 'Qatar',
        cities: ['Doha', 'Al Rayyan', 'Al Wakrah', 'Lusail'],
        employers: [
          'Engineering & Contracting, Qatar',
          'Trading & Facilities Group, Qatar',
          'Hospitality Logistics, Qatar',
          'Civil Infrastructure Co, Qatar',
          'Transport & Fleet Solutions, Qatar',
          'Building Maintenance Services, Qatar',
          'Integrated Logistics, Qatar',
        ],
      ),
    ];

    int jobIndex = 0;

    for (int cycle = 0; cycle < 15; cycle++) {
      for (int pIndex = 0; pIndex < jobProfiles.length; pIndex++) {
        jobIndex++;
        final profile = jobProfiles[pIndex];
        final countryData = countries[jobIndex % countries.length];
        final city =
            countryData.cities[(cycle + pIndex) % countryData.cities.length];
        final employer = countryData
            .employers[(cycle * 2 + pIndex) % countryData.employers.length];

        final baseScore = 98.5 - ((jobIndex * 1.73) % 35.0);
        final matchScore = double.parse(baseScore.toStringAsFixed(1));

        final hasAccommodation = (jobIndex % 4 != 0);
        final hasFood = (jobIndex % 3 == 0);
        const hasVisa = true;

        final salaryShift = ((cycle % 5) * 100);
        final minSal = profile.minSal + salaryShift;
        final maxSal = profile.maxSal + salaryShift;

        final dayOffset = (jobIndex * 3) % 28 + 1;
        final postedAt = DateTime(
          2026,
          9,
          dayOffset,
          9 + (jobIndex % 8),
          (jobIndex * 7) % 60,
        );

        final id = 'job_${1000 + jobIndex}';

        jobs.add(
          Job(
            id: id,
            title: profile.title,
            employerDisplay: employer,
            country: countryData.country,
            city: city,
            salaryMinAed: minSal,
            salaryMaxAed: maxSal,
            matchScore: matchScore,
            matchReason: profile.reason,
            skills: profile.skills,
            benefits: JobBenefits(
              accommodation: hasAccommodation,
              food: hasFood,
              visa: hasVisa,
            ),
            description: profile.desc,
            requirements: profile.reqs,
            postedAt: postedAt,
          ),
        );
      }
    }

    jobs.sort((a, b) => b.matchScore.compareTo(a.matchScore));

    return List.unmodifiable(jobs);
  }
}
