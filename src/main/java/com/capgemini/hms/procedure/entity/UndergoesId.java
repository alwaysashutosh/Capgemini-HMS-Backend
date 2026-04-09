package com.capgemini.hms.procedure.entity;

import jakarta.persistence.Embeddable;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.time.LocalDateTime;

@Embeddable
@Data
@NoArgsConstructor
@AllArgsConstructor
public class UndergoesId implements Serializable {
    private Integer patient;

    @jakarta.persistence.Column(name = "`procedure`")
    private Integer procedure;
    private Integer stay;
    private LocalDateTime dateUndergoes;
}
