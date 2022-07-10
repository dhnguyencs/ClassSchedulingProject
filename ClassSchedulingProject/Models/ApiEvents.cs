﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ClassSchedulingProject.Models
{
    [Table("apiEvents")]
    public partial class ApiEvents
    {
        [Key]
        public int Id { get; set; }
        [Required]
        [Column("eventData")]
        public string EventData { get; set; }
        [Required]
        [Column("eventUUID")]
        [StringLength(256)]
        public string EventUuid { get; set; }
        [Required]
        [Column("eventAuthorHash")]
        [StringLength(512)]
        public string EventAuthorHash { get; set; }
        [Required]
        [Column("institutonID")]
        [StringLength(64)]
        public string InstitutonId { get; set; }
        [Column("year")]
        public int Year { get; set; }
        [Column("quarter")]
        public int Quarter { get; set; }
        [Required]
        [Column("building")]
        [StringLength(64)]
        public string Building { get; set; }
        [Required]
        [Column("room")]
        [StringLength(64)]
        public string Room { get; set; }

        public virtual UserInformation EventAuthorHashNavigation { get; set; }
        public virtual InstitutionsRegistry Instituton { get; set; }
    }
}
